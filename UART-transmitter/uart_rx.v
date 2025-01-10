module uart_rx (
    input wire clk,
    input wire reset,
    input wire rx,
    output reg [7:0] data_out,
    output reg data_ready
);

    parameter CLOCK_FREQ = 50000000; // 50 MHz clock
    parameter BAUD_RATE = 9600;
    parameter BAUD_COUNT = CLOCK_FREQ / BAUD_RATE;

    reg [15:0] baud_counter;
    reg [3:0] bit_counter;
    reg [7:0] rx_shift_reg;
    reg sampling;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            baud_counter <= 0;
            bit_counter <= 0;
            rx_shift_reg <= 0;
            data_out <= 0;
            data_ready <= 0;
            sampling <= 0;
        end else begin
            if (sampling) begin
                if (baud_counter < BAUD_COUNT - 1) begin
                    baud_counter <= baud_counter + 1;
                end else begin
                    baud_counter <= 0;
                    rx_shift_reg <= {rx, rx_shift_reg[7:1]};
                    if (bit_counter < 8) begin
                        bit_counter <= bit_counter + 1;
                    end else begin
                        bit_counter <= 0;
                        data_out <= rx_shift_reg;
                        data_ready <= 1;
                        sampling <= 0;
                    end
                end
            end else if (!rx) begin
                sampling <= 1;
                baud_counter <= 0;
                bit_counter <= 0;
            end else begin
                data_ready <= 0;
            end
        end
    end
endmodule
