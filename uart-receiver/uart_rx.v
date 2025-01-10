module uart_rx (
    input wire clk,           // System clock
    input wire reset,         // Reset signal
    input wire rx,            // UART receive line
    output reg [7:0] data,    // 8-bit data output
    output reg ready     // Data ready signal
);

    parameter CLOCK_FREQ = 50000000;  // 50 MHz clock
    parameter BAUD_RATE = 9600;       // Baud rate for UART
    parameter SAMPLE_COUNT = CLOCK_FREQ / (BAUD_RATE); // Clock cycles per bit

    reg [3:0] bit_count;      // Counter for the bits
    reg [7:0] shift_reg;      // Shift register for received data
    reg [15:0] cycle_count;   // Counter for clock cycles
    reg [1:0] state;          // State machine
    reg rx_sync_0, rx_sync_1; // Synchronize the rx line to clk

    // State machine states
    localparam STATE_IDLE = 2'b00,
               STATE_START = 2'b01,
               STATE_DATA = 2'b10,
               STATE_STOP = 2'b11;

    // Synchronize rx to the clock domain
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rx_sync_0 <= 1'b1;
            rx_sync_1 <= 1'b1;
        end else begin
            rx_sync_0 <= rx;
            rx_sync_1 <= rx_sync_0;
        end
    end

    // UART receiver state machine
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= STATE_IDLE;
            cycle_count <= 16'd0;
            bit_count <= 4'd0;
            ready <= 1'b0;
            data <= 8'd0;
            shift_reg <= 8'd0;
        end else begin
            case (state)
                STATE_IDLE: begin
                    ready <= 1'b0;  // Clear ready in idle state
                    if (!rx_sync_1) begin  // Start bit detected
                        state <= STATE_START;
                        cycle_count <= 16'd0;
                    end
                end
                
                STATE_START: begin
                    if (cycle_count == SAMPLE_COUNT / 2) begin
                        if (!rx_sync_1) begin  // Start bit still valid
                            state <= STATE_DATA;
                            bit_count <= 4'd0;
                            cycle_count <= 16'd0;
                        end else begin
                            state <= STATE_IDLE;
                        end
                    end else begin
                        cycle_count <= cycle_count + 1'b1;
                    end
                end
                
                STATE_DATA: begin
                    if (cycle_count == SAMPLE_COUNT - 1) begin
                        cycle_count <= 16'd0;
                        shift_reg <= {rx_sync_1, shift_reg[7:1]};  // Shift in data bit
                        if (bit_count == 7) begin
                            state <= STATE_STOP;
                        end else begin
                            bit_count <= bit_count + 1;
                        end
                    end else begin
                        cycle_count <= cycle_count + 1'b1;
                    end
                end
                
                STATE_STOP: begin
                    if (cycle_count == SAMPLE_COUNT - 1) begin
                        if (rx_sync_1) begin  // Stop bit should be 1
                            data <= shift_reg;
                            ready <= 1'b1;
                        end
                        state <= STATE_IDLE;  // Return to idle after stop bit
                    end else begin
                        cycle_count <= cycle_count + 1'b1;
                    end
                end
                
                default: state <= STATE_IDLE;
            endcase
        end
    end

endmodule
