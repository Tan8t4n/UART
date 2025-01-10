char lastData = '\0';  // Biến lưu trữ dữ liệu cuối cùng nhận được từ Serial Monitor

void setup() {
  Serial.begin(9600);  // Khởi tạo giao tiếp Serial với máy tính và FPGA
}

void loop() {
  // Kiểm tra nếu có dữ liệu mới từ Serial Monitor
  if (Serial.available() > 0) {
    lastData = Serial.read();  // Cập nhật dữ liệu mới
  }

  // Gửi dữ liệu liên tục sang FPGA
  if (lastData != '\0') {  // Kiểm tra xem có dữ liệu để gửi không
    Serial.write(lastData);
    delay(10);  // Thêm độ trễ để tránh gửi quá nhanh
  }
}
