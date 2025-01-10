module uart_tx (
    input wire clk,            // System clock
    input wire reset,          // Reset signal
    input wire [7:0] data,     // 8-bit data input
    output reg tx,             // UART transmit line
    output reg ready           // Ready signal indicating transmission can start
);

    parameter CLOCK_FREQ = 50000000;  // 50 MHz clock
    parameter BAUD_RATE = 9600;       // Baud rate for UART
    parameter SAMPLE_COUNT = CLOCK_FREQ / (BAUD_RATE);  // Clock cycles per bit

    reg [3:0] bit_count;      // Counter for the bits
    reg [7:0] shift_reg;      // Shift register for transmitting data
    reg [15:0] cycle_count;   // Counter for clock cycles
    reg [1:0] state;          // State machine

    // State machine states
    localparam STATE_IDLE = 2'b00,
               STATE_START = 2'b01,
               STATE_DATA = 2'b10,
               STATE_STOP = 2'b11;

    // UART transmitter state machine
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= STATE_IDLE;
            cycle_count <= 16'd0;
            bit_count <= 4'd0;
            tx <= 1'b1;        // Idle state for UART TX is high
            ready <= 1'b1;
            shift_reg <= 8'd0; // Reset shift register to 0
        end else begin
            case (state)
                STATE_IDLE: begin
                    		tx <=1'b1; 
                        shift_reg <= data;  // Load data into shift register
                        cycle_count <= 16'd0;
                        bit_count <= 4'd0;
                        ready <= 1'b0;
								state <= STATE_START;
                  end
                
                STATE_START: begin
                    tx <= 1'b0;  // Start bit (low)
                    if (cycle_count == SAMPLE_COUNT - 1) begin
                        cycle_count <= 16'd0;
                        state <= STATE_DATA;
                    end else begin
                        cycle_count <= cycle_count + 1;
                    end
                end
                
                STATE_DATA: begin
                    tx <= shift_reg[0];  // Transmit LSB first
                    if (cycle_count == SAMPLE_COUNT - 1) begin
                        cycle_count <= 16'd0;
                        shift_reg <= shift_reg >> 1;  // Shift data
                        if (bit_count < 7) begin
								   bit_count <= bit_count + 1;
                            
                        end else begin
								     bit_count <= 0;
                            state <= STATE_STOP;
                        end
                    end else begin
                        cycle_count <= cycle_count + 1;
                    end
                end
                
                STATE_STOP: begin
                    tx <= 1'b1;  // Stop bit (high)
                    if (cycle_count == SAMPLE_COUNT - 1) begin
                        state <= STATE_IDLE;
                        ready <= 1'b1;  // Transmission complete
                    end else begin
                        cycle_count <= cycle_count + 1;
                    end
                end
                
                default: state <= STATE_IDLE;
            endcase
        end
    end

endmodule
