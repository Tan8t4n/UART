module tb_top();

    reg clk;
    reg rst;
    reg [7:0] switch;
    wire uart_tx;

    top uut (
        .clk(clk),
        .reset(rst),
        .switch(switch),
        .tx(uart_tx)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 50 MHz clock
    end

    // Test sequence
    initial begin
        // Initialize
        rst = 1;
		  switch = 8'b0000000;
        #104167; // Wait for reset to propagate
        // Release reset
        rst = 0;
        
        
             
        
        // Test different switch values
		  switch = 8'b00110001; #(104167*9);
		  
		          // Finish simulation
			#10000000
        $stop;
    end

endmodule
