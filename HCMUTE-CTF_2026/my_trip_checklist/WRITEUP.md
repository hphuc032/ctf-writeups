# My Trip Checklist

## Thông tin

- **Thể loại:** Forensics / Office Document
- **File:** `planning.rar`
- **Flag:** `UTECTF{1_b3li3v3_1n_H4im1y@_SuPr3m4cY_l0v3}`

## 1. Giải nén archive

Mật khẩu RAR là URL YouTube trong đề:

```text
Enjoy_this_song_https://youtu.be/CTdGQIeWQM0?si=k6r7nocSprXxHx69
```

Archive chứa file `planning.xlsx`.

## 2. Nhận diện lớp mã hóa

Mặc dù có đuôi `.xlsx`, file không phải ZIP OOXML thông thường mà là OLE Compound File. Bên trong có các stream:

```text
EncryptionInfo
EncryptedPackage
DataSpaces
```

Điều này cho biết toàn bộ workbook được mã hóa bằng Office Agile Encryption, không chỉ khóa chỉnh sửa worksheet. `EncryptionInfo` cho biết cấu hình:

- AES-256-CBC
- SHA-512
- Salt 16 byte
- 100.000 vòng dẫn xuất khóa

Không thể đổi đuôi rồi mở trực tiếp bằng ZIP; trước hết cần khôi phục mật khẩu Excel.

## 3. Khôi phục mật khẩu Excel

Trích salt và verifier từ `EncryptionInfo`, sau đó chuyển sang định dạng hashcat Office (mode `9600`) để thử mật khẩu offline. Các wordlist nhỏ và dãy số không cho kết quả. Dictionary lớn tìm được:

```text
P@ssW0rd
```

Mật khẩu được xác nhận bằng verifier của Office và kiểm tra toàn vẹn sau khi giải mã.

Hash dùng cho Hashcat:

```text
$office$*2013*100000*256*16*0a7688d02a5ad5f72de3014a03ec7675*ea40a7da24da4d21d1ba99e78ef60e26*866f1c09e320e7aa4d71d9542463f75faa3c55ede442cb253ad515c3c8a30134
```

Lệnh tham khảo:

```powershell
.\hashcat.exe -m 9600 -a 0 ..\..\office.hash ..\..\top-1000000.txt --potfile-path ..\..\planning.pot
```

## 4. Phân tích workbook đã giải mã

Sau khi giải mã, workbook trở thành ZIP OOXML. `xl/workbook.xml` cho thấy có sheet ẩn tên `Haimiya`:

```xml
<sheet name="Haimiya" sheetId="2" state="hidden" r:id="rId2"/>
```

Lần theo `xl/_rels/workbook.xml.rels`, sheet này trỏ tới `xl/worksheets/sheet2.xml`. Ô `Haimiya!A1` chứa phần đầu flag:

```text
UTECTF{1_b3li3v3_1n
```

Sheet có `sheetProtection`, nhưng đây chỉ là khóa thao tác trong giao diện; dữ liệu XML vẫn đọc được sau khi giải mã workbook. Không cần crack khóa sheet.

## 5. Tìm phần còn lại của flag

Sheet `Haimiya` có drawing. Lần theo quan hệ từ worksheet đến `xl/drawings/drawing2.xml`, ta thấy thuộc tính mô tả của `Picture 2`:

```xml
<xdr:cNvPr id="3" name="Picture 2" descr="_H4im1y@_SuPr3m4cY_l0v3}" />
```

Thuộc tính `descr` chính là alt text của ảnh và chứa phần cuối flag. Ghép với nội dung ô A1:

```text
UTECTF{1_b3li3v3_1n_H4im1y@_SuPr3m4cY_l0v3}
```

Không cần OCR hoặc phân tích pixel ảnh; dữ liệu nằm trong metadata XML của drawing.

## 6. Tái hiện

Script [solve.py](D:/CTF-HCMUTE-2026/my_trip_checklist/solve.py) giải mã workbook, kiểm tra CRC ZIP, đọc ô `Haimiya!A1`, lần theo quan hệ drawing và ghép flag:

```powershell
python -m pip install msoffcrypto-tool
python .\my_trip_checklist\solve.py
```

Có thể chỉ định file và mật khẩu:

```powershell
python .\my_trip_checklist\solve.py .\my_trip_checklist\planning.xlsx --password 'P@ssW0rd'
```

## Kết luận

Bài gồm nhiều lớp: RAR có mật khẩu, workbook Office Agile được mã hóa bằng mật khẩu yếu, sau đó flag được chia giữa một sheet ẩn và metadata `descr` của ảnh. Điểm mấu chốt là nhận diện đúng định dạng OLE, crack mật khẩu Office offline và kiểm tra toàn bộ cấu trúc OOXML thay vì chỉ nhìn giao diện Excel.

## Tham khảo

- [Microsoft — Agile Encryption](https://learn.microsoft.com/en-us/openspecs/office_file_formats/ms-offcrypto/74d60145-a0f0-44be-99ce-c65d211b4eb7)
- [Hashcat example hashes](https://hashcat.net/wiki/doku.php?id=example_hashes)
- [msoffcrypto-tool](https://github.com/nolze/msoffcrypto-tool)
