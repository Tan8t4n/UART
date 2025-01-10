module top (
    input wire clk,
    input wire rx,
	 input wire reset,
    output wire [7:0] leds,
	 output wire [6:0] segs,
	 output led2,
	 output wire ready
);

    wire [7:0] data;
    wire data_ready;

    uart_rx uart_receiver (
    .clk(clk),
    .reset(reset),
    .rx(rx),
    .data(data),
    .ready(ready)
);
  

led_display led_dis_inst (
        .clk(clk),
        .reset(reset),
        .uart_data(data),
        .uart_ready(ready),
        .led(leds)
    );
	 
	ascii_to_7_segment led_7_seg (
	.ascii_code(data),
   .seven_seg(segs)
	);
	 
	 assign led2 = reset;
endmodule
