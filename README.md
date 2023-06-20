# SE104.N25.CLC - Nhóm 8
#### []*Phần mềm: Quản lý học sinh


## [] Giới thiệu

Trong thời đại mà dân số thế giới đang tăng nhanh theo cấp số nhân kéo theo đó là sự tăng lên về số lượng học sinh được học tập và rèn luyện tại khắp các trường trên toàn thế giới. Với việc quản lý và lưu trữ trên sổ ghi tay đã tỏ ra nhiều nhược điểm như dễ bị thất lạc dữ liệu, tốn khá nhiều không gian lưu trữ,… Một học sinh khi muốn truy vấn lại thông tin của mình sẽ gặp rất nhiều khó khăn, vì có rất nhiều thông tin quan trọng cần lưu trữ như thông tin cá nhân, điểm số cho các môn học khác nhau, các văn bằng, tín chỉ,… Đây là một lượng thông tin khổng lồ và mang tính phức tạp nếu vẫn tiếp tục giữ việc lưu trữ dữ liệu học sinh trên số sách viết tay sẽ khiến cho công việc này dần mất đi tính khả thi. Hơn thế nữa, quản lý một học sinh còn có yêu cầu cao về độ chính xác trong việc kiểm kê số liệu, thống kê các điểm số cho từng sinh viên, của từng môn và từng lớp khác nhau. Chính vì thế, việc chuyển đổi lưu trữ dữ liệu sinh viên từ sổ sách ghi tay sang lưu trữ trên một hệ thống là một yêu cầu cấp thiết.
Cùng với đó là sự chuyển đổi số đang được đẩy nhanh trên khắp mọi lĩnh vực đi đầu là các ngành trong lĩnh vực công nghệ thông tin đòi hỏi phải đẩy nhanh tiến độ chuyển đổi cách lưu trữ dữ liệu. Việc quản lý học sinh trên một ứng dụng trực tuyến sẽ giúp tự động hóa quá trình lưu trữ thông tin học sinh. Thay vì phải ghi chép bằng tay và tìm kiếm thông tin trong sổ sách, người dùng có thể nhanh chóng tìm kiếm, cập nhật và xử lý thông tin chỉ bằng vài cú nhấp chuột. Hơn thế nữa, hệ thống ứng dụng phần mềm sẽ cung cấp tính năng lưu trữ dữ liệu học sinh theo một cấu trúc và có thể tìm kiếm theo nhiều tiêu chí. Người dùng có thể dễ dàng xem thông tin về học sinh, điểm số, hồ sơ về quá trình học tập và sự tiến bộ của từng học sinh. Ngoài ra, việc sử dụng phần mềm sẽ giảm thiểu khả năng mắc sai sót trong quá trình nhập liệu cũng như là lưu trữ dữ liệu. Dữ liệu khi được nhập vào hệ thống sẽ phải có tính chính xác cao, nếu có lỗi sẽ có thể dễ dàng kiểm tra và sửa lỗi khi cần thiết. Trên hết, ứng dụng có thể cho phép người dùng chia sẻ thông tin học sinh với giáo viên, phụ huynh,… một cách nhanh chóng và thuận tiện, các thông báo, bản tin và báo cáo tình hình học tập có thể được hệ thống gửi đi một cách tự động.
Chính vì các lý do và ưu điểm đã nêu trên, nhóm 8 đã chọn đề tài “Quản lý học sinh” để làm đề tài cho đồ án cuối kỳ của môn học “Nhập môn công nghệ phần mềm”. Để đáp ứng được các tiện ích cũng như nhu cầu của tình hình thực tế đã đưa ra, nhóm 8 đã áp dụng những kỹ thuật thiết kế và lập trình đã được học nhằm xây dựng một website mang tính chuẩn hóa cao cũng như đẩy nhanh tốc độ của 6 nghiệp vụ chính của một hệ thống quản lý trường học:
•	Quản lý tiếp nhận học sinh
•	Lập danh sách lớp
•	Tra cứu học sinh
•	Nhận bảng điểm môn học
•	Lập báo cáo tổng kết
•	Thay đổi quy định
Sau khi tiến hành nghiên cứu và thiết kế, nhóm 8 sẽ trình bày nội dung chính mà nhóm đã tìm hiểu được cũng như các sơ đồ đã sử dụng để xây dựng thành công ứng dụng đáp ứng các nhu cầu của thực tiễn và việc quản lý học sinh đặt ra.


## [] Tính năng

- Tiếp nhận học sinh
- Tiếp nhận giáo viên
- Lập danh sách lớp
- Thêm giáo viên vào lớp
- Thêm môn học vào lớp
- Tra cứu học sinh
- Tra cứu lớp học
- Quản lý môn học
- Nhận bảng điểm môn
- Lập báo cáo tổng kết
- Đăng bài thông báo
- Xem thông tin thông báo
- Thay đổi qui định
- Thêm vai trò người dùng
- Cho học sinh lên lớp

## [](https://github.com/UIT-21522120/nmcnpm/tree/main)Công nghệ sử dụng
 - Front-end:
  + HTML: Pug - Template Preprocessor là một cú pháp để viết html
  + CSS: Bootstrap 4 là phiên bản mới của Bootstrap, là framework HTML, CSS và JavaScript phổ biến nhất để thiết kế web đáp ứng, ưu tiên trên nền tảng di động.
  + Javascript
 - Back-end:
  + Nodejs - Xử lý API, Back-end
  + Express - Framework nằm trên chức năng máy chủ web của NodeJS
  + CSDL: MS SQL Server

## []Cài đặt

Yêu cầu:  [Node.js](https://nodejs.org/)  v19+ để có thể chạy chương trình.
Mở port 1433 cho phép kết nối với MS SQL Server
Cài đặt các thư viện cần thiết và CSDL theo file .sql đã upload

```
npm install
npm install mssql
npm install msnodesqlv8
npm dotenv 
npm run start
```
