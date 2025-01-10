// Thiết lập tốc độ baud rate cho UART
const unsigned long BAUD_RATE = 9600;

// Biến lưu trữ giá trị nhận được lần cuối
int lastReceivedValue = -1;

void setup() {
    // Khởi tạo UART cho Serial Monitor và Serial Plotter
    Serial.begin(BAUD_RATE);
}

void loop() {
    // Kiểm tra nếu có dữ liệu nhận được từ FPGA qua UART
    if (Serial.available() > 0) {
        // Đọc dữ liệu từ FPGA
        int receivedValue = Serial.read();

        // Chuyển đổi giá trị nhận được từ byte sang dạng số nguyên 8 bit (0-255)
        int dataValue = receivedValue;

        // Kiểm tra xem giá trị hiện tại có khác với giá trị cuối cùng đã nhận không
        if (dataValue != lastReceivedValue) {
            // Mã hóa giá trị nhận được thành ký tự ASCII
            char asciiChar = (char)dataValue;

            // Xuất dữ liệu mã hóa ra Serial Monitor
            Serial.print("Received ASCII character: ");
            Serial.println(asciiChar);

            // Xuất dữ liệu ra Serial Plotter
            Serial.println(dataValue);

            // Cập nhật giá trị cuối cùng đã nhận
            lastReceivedValue = dataValue;
        }
    }
}
