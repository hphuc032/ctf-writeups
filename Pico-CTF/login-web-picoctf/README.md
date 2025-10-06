---
title: ctf-writeups

---

# ctf-writeups
Write-ups and notes for Capture The Flag (CTF) challenges
## 🧩 Challenge: login - picoCTF - Web

### 📜 Mô tả đề:
> Tìm cách để đăng nhập vào trang web

>Nhập URL tệp bạn muốn tải lên vào trường được cung cấp.
Nhấp vào nút "Tải lên".
Trang web sẽ lấy tệp, lưu trữ an toàn và hiển thị để bạn thuận tiện theo dõi.

### 📁 File đính kèm:
- https://login.mars.picoctf.net/

### 🎯 Mục tiêu:
> đăng nhập vào được trang web để lấy cờ 

---

### 🔍 Phân tích đề:
- ta sẽ check source code đầu tiền để coi thử trong đó có gì không
- 

---

### 🔧 Khai thác:
- và thực sự khi xem source ta thấy cái file `index.js` ta thử bấm vào và thấy có 1 dòng kí tự lạ
- ![image](https://hackmd.io/_uploads/BJ_J2r9Hge.png)

- bây giờ ta sẽ coppy đoạn chữ màu xanh trong ngoặc kép đó :cGljb0NURns1M3J2M3JfNTNydjNyXzUzcnYzcl81M3J2M3JfNTNydjNyfQ
- chỉ cần lên gg search decode base64 rồi dán đoạn chữ đó vào rồi nhấn decode
- ![image](https://hackmd.io/_uploads/rJJC2BcBlg.png)
và chúng ta đã có flag đem đi nộp thôi em trai
