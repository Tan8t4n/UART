module switch_encoder(
    input wire [7:0] switch,  // 8 switch đầu vào
    output reg [7:0] data     // Dữ liệu đọc từ switch
);
    always @(*) begin
        data = switch;
    end
endmodule
