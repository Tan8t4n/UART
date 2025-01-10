

module tb_top;

    // Testbench signals
    reg clk;
    reg reset;
    reg rx;
    wire [7:0] data;
    wire ready;

    // Instantiate the uart_rx module
    uart_rx uut (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .data(data),
        .ready(ready)
    );

    // Clock generation
    parameter CLOCK_PERIOD = 20; // 50 MHz clock
    initial begin
        clk = 0;
        forever #(CLOCK_PERIOD/2) clk = ~clk;
    end

    // Test procedure
    initial begin
        // Initialize signals
        reset = 1;
        rx = 1;

        // Apply reset
        #1000;
        reset = 0;

 
        // Simulate sending multiple bytes
        send_byte(8'b01010101);  // Send byte 0x55
       
        

        send_byte(8'b10101010);  // Send byte 0xAA
        
        

        send_byte(8'b11110000);  // Send byte 0xF0
        
        

        send_byte(8'b00001111);  // Send byte 0x0F
        #1000000
        

        // End the simulation
                $stop;
    end

    // Task to simulate sending a byte via UART
    task send_byte;
        input [7:0] byte;
        integer i;
        begin
            // Start bit
            rx = 0;
            #(CLOCK_PERIOD * uut.SAMPLE_COUNT);

            // Data bits
            for (i = 0; i < 8; i = i + 1) begin
                rx = byte[i];
                #(CLOCK_PERIOD * uut.SAMPLE_COUNT);
            end

            // Stop bit
            rx = 1;
            #(CLOCK_PERIOD * uut.SAMPLE_COUNT);
        end
    endtask

endmodule
