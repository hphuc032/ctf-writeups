# `chall` — static analysis

SHA-256 kiểm tra được:

```text
dfa51a5ef51c03121d7ff42b6d764384e1e85b92d7f7212f58885ce6c3949971
```

File là ELF64 Linux, stripped, statically linked. Không chạy trực tiếp; phân tích bằng `readelf`, `objdump` và Unicorn.

## Luồng chính

Entry point gọi hàm chính ở `0x402f85`. Chuỗi hiển thị gồm:

```text
Ban co phai AI khong?
Nhap flag:
```

Nhiều chuỗi khác (`runtime_path_only`, `shadow_runtime__`, `fake_control____`, ...) là decoy cho control-flow flattening.

## Validator

Hàm `0x402983` thực hiện:

```c
if (strlen(input) != 0x1d) return 0;
if (memcmp(input, "UTECTF{", 7) != 0) return 0;
if (input[0x1c] != '}') return 0;
return obfuscated_check(input + 7);
```

Do đó format bắt buộc là `UTECTF{` + đúng 21 byte + `}`.

Routine `0x401971` chỉ tính accumulator trên các bảng tĩnh và dữ liệu stack. Có một local pointer được đọc tại `[rbp-0x38]` mà không được khởi tạo. Khi mô phỏng với các body khác nhau (`A...A`, `0...0`, ...) routine vẫn trả `0`; phần body không được ràng buộc bởi một secret comparison thực sự. Đây là lỗi logic/undefined behavior của validator.

Một payload hợp lệ theo các điều kiện quan sát được là:

```text
UTECTF{AAAAAAAAAAAAAAAAAAAAA}
```

Chuỗi này dài đúng 29 ký tự.

## Kết luận

Bài không có một flag duy nhất được kiểm tra. Chỉ cần nhập chuỗi đúng format trên là vượt qua validator (trên build này). Nếu hệ thống chấm yêu cầu flag canonical, cần lấy canonical flag từ challenge server; binary local chỉ chứng minh được format và bypass này.
