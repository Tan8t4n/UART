module led_display (
    input wire clk,           // System clock
    input wire reset,         // Reset signal
    input wire [7:0] uart_data, // 8-bit data from UART
    input wire uart_ready,    // Signal indicating new data received
    output reg [7:0] led      // 8-bit LED output
);

    // State machine to hold LED output until new data is received
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            led <= 8'd0; // Reset LED output
        end else if (uart_ready) begin
            led <= uart_data; // Update LED output with new UART data
        end
    end

endmodule
