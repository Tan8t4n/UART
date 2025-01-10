module top (
    input wire clk,
    input wire reset,
    input wire [7:0] switch,
    output wire tx,
	 output [7:0] led,
	 output led2,
	 output [6:0] segs
	 
);
       wire ready;
	 
    
    uart_tx uart_tx_inst (
        .clk(clk),
        .reset(reset),
        .data(switch),
        .tx(tx),
		  .ready(ready)
		            );
	ascii_to_7_segment led_7_seg (
	.ascii_code(switch),
	.seven_seg(segs)
	
	);
	
    assign led = switch; 
	 assign led2 = reset;
	 
endmodule