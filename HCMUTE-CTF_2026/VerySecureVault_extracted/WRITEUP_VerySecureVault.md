# A Very Secure Vault

## Thông tin

- **Thể loại:** Reverse engineering / Cryptography / Forensics
- **File:** `VerySecureVault.rar`
- **Flag:** `UTECTF{h0llY_sh1t_Th1s_v4ulT_4r3n'T_s3cUr3_4s_1t_s33m}`

## 1. Giải nén và khảo sát ứng dụng

Mật khẩu RAR được cho trong đề:

```text
Enjoy_this_https://youtu.be/cK1ABiGuiG0?si=YZXMRIceu6tV7RDy
```

Sau khi giải nén, challenge gồm ứng dụng .NET `SecureNote` và file vault:

```text
App/MyDearPasswordProtector.db.ecdh
```

Decompile `SecureNote.dll` cho thấy các hàm quan trọng:

- `CreateMasterPassword`
- `GenerateKeyAndIV`
- `EncryptAesCbc` / `DecryptAesCbc`
- `SaveEncryptedData` / `ReadFile`

## 2. Phân tích định dạng vault

Ứng dụng không lưu ciphertext thuần túy. `SaveEncryptedData` thực hiện:

1. Băm master password bằng SHA-256 và biểu diễn dưới dạng chuỗi hex thường.
2. Dùng hash và timestamp để tạo khóa AES/IV.
3. Mã hóa database SQLite bằng AES-CBC.
4. Ghép dữ liệu theo dạng:

   ```text
   <hash_hex> | <ciphertext_hex> | <timestamp>
   ```

5. XOR từng byte của chuỗi trên với hash SHA-256 lặp lại.

Nếu đặt `K = SHA256(master_password)` thì khóa XOR có 32 byte. Phần plaintext đầu tiên lại là `K.hex()`, tức 64 ký tự ASCII có cấu trúc đã biết. Với mỗi byte:

```text
plaintext[i] = ciphertext[i] XOR K[i % 32]
```

Do `plaintext[i]` chính là một nibble trong `K.hex()`, ta có thể thử các giá trị byte 0–255 và lan truyền các ràng buộc để khôi phục toàn bộ `K`, không cần brute-force master password.

Hash khôi phục được:

```text
c0e223b2e75cf19d75cb8663c440d407a01fd55d090e9059c29ea52e923f73c4
```

XOR ngược toàn bộ file cho kết quả hợp lệ:

```text
c0e223b2e75cf19d75cb8663c440d407a01fd55d090e9059c29ea52e923f73c4 |
<ciphertext_hex> |
2026-09-11T23:20:22.6300456+07:00
```

## 3. Tái tạo khóa AES

`GenerateKeyAndIV` sử dụng Bouncy Castle với đường cong `secp256r1`:

```text
d1 = SHA256(UTF8(hash_hex)) mod n
d2 = SHA256(UTF8(timestamp)) mod n
Q  = (d1 * d2)G
S  = SHA512(X-coordinate(Q))
AES key = S[0:32]
IV      = S[32:48]
```

Với dữ liệu của challenge:

```text
AES key = 91527c29363abd5be84207219f968f54ba1cfa2005676603b73ea6a8fc01cbe2
IV      = 67bfb4b4cbe3900a5368fbf325c312cf
```

Giải mã trường ciphertext bằng AES-256-CBC với PKCS#7 padding cho header chuẩn:

```text
SQLite format 3\0
```

## 4. Trích xuất flag

Database SQLite sau khi giải mã có bảng `entries`. Bản ghi `SuperSecretPassword` chứa flag trong trường password:

```text
UTECTF{h0llY_sh1t_Th1s_v4ulT_4r3n'T_s3cUr3_4s_1t_s33m}
```

## 5. Tái hiện

Script giải bài: [solve_vault.py](D:/CTF-HCMUTE-2026/VerySecureVault_extracted/solve_vault.py)

Trong quá trình phân tích có thể tạo các artifact trung gian như wrapper sau XOR và
database SQLite đã giải mã. Đây là file tạm, không cần đưa vào repository.

## Nguyên nhân lỗi

Thiết kế thất bại vì:

1. Dùng XOR lặp với khóa ngắn.
2. Ghi chính khóa XOR ở đầu plaintext, tạo known-plaintext attack trực tiếp.
3. Giá trị dùng để sinh ECDH/AES là deterministic và đều xuất hiện trong wrapper.

Vì vậy, chỉ cần khôi phục SHA-256 của master password và timestamp là có thể tái tạo AES key/IV, giải mã vault và đọc dữ liệu.
