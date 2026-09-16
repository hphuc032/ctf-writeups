# Bò ba lan

## Thông tin

- **Thể loại:** Steganography
- **File:** `public.rar`
- **Flag:** `UTECTF{0lD_bUt_g0lD_Moooooooooooooooooooooo}`

## 1. Giải nén file

Mật khẩu của archive là toàn bộ URL YouTube trong đề, bao gồm cả phần query string:

```text
https://youtu.be/CTdGQIeWQM0?si=nm-H94KbMOGaX8-v
```

Giải nén bằng `7z`:

```powershell
7z x '-phttps://youtu.be/CTdGQIeWQM0?si=nm-H94KbMOGaX8-v' .\public.rar -o.\public
```

Archive chứa 40 video, từ `video_001.mp4` đến `video_040.mp4`.

## 2. Tìm các frame bất thường

Các video có cùng thông số hình ảnh. Phần âm thanh AAC của những video đầu cũng trùng nhau, với SHA-256:

```text
3753f061ea87a1e934a318e64c5085c59000dfcfcad3ff8fb5f2e47088f7b81a
```

Vì vậy, ta giải mã video thành các frame và so sánh những frame có cùng chỉ số giữa các video. Các điểm khác biệt tập trung ở vùng góc dưới bên phải. Đây là những nhãn chữ chỉ xuất hiện trong đúng một frame.

Một số nhãn thu được:

```text
video_001.mp4: 0U:V (frame 384), 1U:V (frame 1747)
video_002.mp4: 2U:R (frame 336), 3U:F (frame 1908)
```

Nhãn chỉ tồn tại trong một frame (khoảng vài chục mili-giây), nên xem video bằng mắt thường rất khó phát hiện.

## 3. Giải mã các nhãn

Các nhãn có dạng:

```text
<index><mode>:<character>
```

Trong đó:

- `index` là vị trí của ký tự trong chuỗi cần khôi phục.
- `U` chuyển ký tự thành chữ hoa.
- `L` chuyển ký tự thành chữ thường.
- `-` giữ nguyên ký tự.

Sau khi thu thập tất cả nhãn, sắp xếp theo `index` từ 0 đến 59 rồi áp dụng quy tắc hoa/thường. Chuỗi thu được là một chuỗi Base64:

```text
VVRFQ1RGezBsRF9iVXRfZzBsRF9Nb29vb29vb29vb29vb29vb29vb29vb30=
```

## 4. Decode Base64

Có thể giải mã bằng PowerShell:

```powershell
[Text.Encoding]::UTF8.GetString(
    [Convert]::FromBase64String('VVRFQ1RGezBsRF9iVXRfZzBsRF9Nb29vb29vb29vb29vb29vb29vb29vb30=')
)
```

Kết quả:

```text
UTECTF{0lD_bUt_g0lD_Moooooooooooooooooooooo}
```

## 5. Script tái hiện

Trong thư mục challenge có hai script hỗ trợ:

```powershell
python .\bo_ba_lan\analyze.py labels
python .\bo_ba_lan\solve.py
```

`analyze.py` cắt vùng góc dưới bên phải, tạo ảnh nền tham chiếu từ các frame và tính độ khác biệt để tìm frame chứa nhãn. `solve.py` đọc các nhãn, sắp xếp theo chỉ số, áp dụng quy tắc hoa/thường và decode chuỗi kết quả.

Một số file bằng chứng được tạo ra:

- `contact.png`: ảnh liên hệ các frame.
- `differences.png`: vùng khác biệt giữa các frame.
- `labels.png`: các nhãn đã cắt.
- `label_frames.json`: vị trí frame của từng nhãn.

## Kết luận

Challenge sử dụng steganography dạng temporal: mỗi ký tự được giấu trong một frame duy nhất của các video gần như giống nhau. Đọc nhãn, sắp xếp đúng thứ tự và giải mã Base64 sẽ thu được flag.

