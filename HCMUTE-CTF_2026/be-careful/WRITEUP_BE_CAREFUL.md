# BE CAREFUL — Writeup

## Thông tin

| Mục | Giá trị |
| :--- | :--- |
| Tên bài | BE CAREFUL |
| Flag format | `UTECTF{...}` |
| SHA-256 | `dfa51a5ef51c03121d7ff42b6d764384e1e85b92d7f7212f58885ce6c3949971` |
| File | ELF 64-bit, statically linked, stripped |

## 1. Ý tưởng chính: đừng dừng ở validator đầu tiên

Chạy `strings` thấy nhiều chuỗi gây nhiễu:

```text
runtime_path_only
shadow_runtime__
runtime_decoy__
runtime_shadow_
static_path_only
```

Hàm `main` bị làm phẳng control flow, nên nhìn lướt rất dễ chỉ thấy validator tại `0x402983`:

```c
if (strlen(flag) != 29) return 0;
if (memcmp(flag, "UTECTF{", 7) != 0) return 0;
if (flag[28] != '}') return 0;
return vm_check_static(flag + 7);
```

Validator này có seed `0x46`, program bắt đầu ở `0x47b220`, và gọi VM với độ dài `0xf8`.

Nó cho ra chuỗi dễ đọc:

```text
UTECTF{st4t1c_4n4lys1s_w0rk5}
```

Tuy nhiên flag đó bị server từ chối. Đây chính là bẫy của đề: static VM chỉ kiểm tra **7 bit trên mỗi byte**, vì thế có nhiều nghiệm printable. Nó là nhánh/decoy để đánh lạc hướng.

Một validator khác nằm tại `0x402a1d` mới là nhánh runtime cần giải:

```c
return vm_check_runtime(
    0x47b700, // bytecode
    0x11c,    // number of VM instructions
    0x52,     // program-decoding seed
    0x47b020, // lookup table
    flag + 7
);
```

Phần khởi tạo runtime/control-flow flattened quyết định nhánh này; do đó mô phỏng riêng `main` mà không mô phỏng đúng startup state có thể đi vào nhánh static giả.

## 2. Giải mã bytecode

VM không đọc bytecode trực tiếp. Mỗi byte tại vị trí `i` được XOR với một keystream phụ thuộc seed.

```c
uint8_t decode(uint8_t *buf, unsigned i, uint8_t seed) {
    uint8_t v = seed ^ 0xa7;
    for (unsigned j = 0; j <= i; j++)
        v = ((v * 73 + j + 0x29) ^ (v >> 3)) & 0xff;
    return buf[i] ^ v;
}
```

Mỗi instruction gồm 5 byte. Với runtime VM (seed `0x52`), chương trình đã giải mã có cấu trúc:

| Instruction range | Chức năng |
| :--- | :--- |
| `0..19` | Hoán đổi các byte flag |
| `20..82` | Với mỗi byte: XOR hằng số, tra bảng, rotate-left |
| `83..110` | Trộn các byte bằng XOR và cộng modulo 256 |
| `111..278` | So sánh từng bit của trạng thái cuối |
| `279..283` | Nhánh fail/success và kết thúc VM |

Các opcode quan trọng:

```text
01 a b      swap(buf[a], buf[b])
02 a k      buf[a] ^= k
03 a page   buf[a] = decoded_table[page * 256 + buf[a]]
04 a n      buf[a] = rol8(buf[a], n)
05 a c      kiểm tra bit ((buf[a] >> ((c >> 1) & 7)) & 1) == (c & 1)
08 a b      buf[a] ^= buf[b]
09 a b      buf[a] += buf[b]       // modulo 256
```

## 3. Đảo VM

Các phép biến đổi trước bước kiểm tra đều đảo được:

```text
rol(x, n)       -> ror(x, n)
xor(x, k)       -> xor(x, k)
S-box(x)        -> inverse_S-box(x)
x = x xor y     -> x = x xor y
x = x + y        -> x = x - y mod 256
swap(a, b)       -> swap(a, b)
```

Khác với static VM, runtime VM có **168 bit checks = 21 × 8 bit**. Toàn bộ 21 byte cuối đã được xác định hoàn toàn. Chỉ cần:

1. Gom các opcode `05` để dựng 21 byte trạng thái cuối.
2. Đảo lần lượt các phép trộn byte (`09`, `08`).
3. Đảo rotate, inverse lookup table và XOR cho từng byte.
4. Đảo các phép swap đầu chương trình.

Kết quả body 21 byte là:

```text
n3w_VM_l4y3r_no_le4ks
```

## 4. Flag

```text
UTECTF{n3w_VM_l4y3r_no_le4ks}
```

## Ghi chú

Thông điệp `Sometimes you have to be careful not because it's dangerous` ám chỉ không nên thấy một validator “có vẻ chạy được” rồi dừng lại. Ở đây, nhánh static không nguy hiểm nhưng cố tình thiếu ràng buộc, còn runtime VM mới giữ toàn bộ 8 bit của mỗi ký tự.
