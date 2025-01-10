module ascii_to_7_segment(
    input [7:0] ascii_code, // Mã ASCII đầu vào (8-bit)
    output reg [6:0] seven_seg // Xuất ra LED 7 đoạn (7-bit)
);

// Giải mã mã ASCII thành mã LED 7 đoạn với bit đảo ngược
always @(ascii_code) begin
    case (ascii_code)
        8'h30: seven_seg = 7'b1000000; // '0'
        8'h31: seven_seg = 7'b1111001; // '1'
        8'h32: seven_seg = 7'b0100100; // '2'
        8'h33: seven_seg = 7'b0110000; // '3'
        8'h34: seven_seg = 7'b0011001; // '4'
        8'h35: seven_seg = 7'b0010010; // '5'
        8'h36: seven_seg = 7'b0000010; // '6'
        8'h37: seven_seg = 7'b1111000; // '7'
        8'h38: seven_seg = 7'b0000000; // '8'
        8'h39: seven_seg = 7'b0010000; // '9'
        8'h41: seven_seg = 7'b0001000; // 'A'
        8'h42: seven_seg = 7'b0000011; // 'b'
        8'h43: seven_seg = 7'b1000110; // 'C'
        8'h44: seven_seg = 7'b0100001; // 'd'
        8'h45: seven_seg = 7'b0000110; // 'E'
        8'h46: seven_seg = 7'b0001110; // 'F'
        // Bạn có thể thêm các ký tự khác ở đây
        default: seven_seg = 7'b1111111; // Mặc định: tắt LED nếu ký tự không hợp lệ
    endcase
end
endmodule 