# SE104.N25.CLC - Nhóm 8
#### *Phần mềm: Quản lý học sinh


## Giới thiệu

Việc quản lý học sinh trên sổ sách tạo ra một gánh nặng đáng kể cho nhân viên nhà trường. Đối với các trường có số lượng học sinh ít và có hạn chế về tài chính, việc quản lý trên sổ sách vẫn có thể thực hiện được. Tuy nhiên, đối với các trường tại các thành phố lớn, có điều kiện tài chính và số lượng học sinh lớn, việc quản lý truyền thống như vậy sẽ mất rất nhiều thời gian và công sức. Mỗi học sinh có rất nhiều thông tin cá nhân, bao gồm cột điểm của các môn học khác nhau và các vấn đề liên quan. Lượng thông tin vô cùng khổng lồ và việc quản lý truyền thống lúc này không còn khả thi với số lượng thông tin lớn như vậy. Ngoài ra, việc quản lý học sinh còn đòi hỏi kiểm kê dữ liệu, thống kê điểm số từng học sinh, từng môn, và từng lớp. Vì vậy, sự chuyển đổi từ quản lý trực tiếp sang quản lý trực tuyến là hoàn toàn cần thiết.


## Tính năng

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

## Công nghệ sử dụng
 Front-end:
  + HTML: Pug - Template Preprocessor là một cú pháp để viết html
  + CSS: Bootstrap 4 là phiên bản mới của Bootstrap, là framework HTML, CSS và JavaScript phổ biến nhất để thiết kế web đáp ứng, ưu tiên trên nền tảng di động.
  + Javascript.
 
 Back-end:
  + Nodejs - Xử lý API, Back-end
  + Express - Framework nằm trên chức năng máy chủ web của NodeJS
  + CSDL: MS SQL Server

## Cài đặt

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
