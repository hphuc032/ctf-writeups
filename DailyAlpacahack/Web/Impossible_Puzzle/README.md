<<<<<<< HEAD
#  Challenge: Impossible Puzzle

- **Category:** [ Web ]
- **Difficulty:** [Easy ]
- **Author:** 
- **Platform:** https://alpacahack.com/daily/challenges/impossible-puzzle?month=2026-04

---

##  Mô tả | Description

**🇻🇳 Tiếng Việt:**  
Hãy nhập 2 chuỗi A và B. Nếu nó bằng nhau về nội dung nhưng khác nhau trong độ dài, thì sẽ lấy được flag!

**🇬🇧 English:**  
Enter two strings A and B. If they are equal in content but different in length, you will get the flag!

---

## Code
```
<?php

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $A = $_POST['A'] ?? '';
    $B = $_POST['B'] ?? '';

    // type check
    if (!is_string($A) || !is_string($B)) {
        die('Invalid input');
    }
    // check
    if (strlen($A) != strlen($B) && $A == $B){
        echo "<blockquote>Congratulations! Here is your flag:\n" . getenv('FLAG') . "</blockquote>";
    }
    else {
        echo "<blockquote>Try again!</blockquote>";
    }
}

?>

<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8" />
    <title>Impossible Puzzle</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://unpkg.com/sakura.css/css/sakura.css" type="text/css" />
    <script src="https://cdn.jsdelivr.net/npm/dompurify@3.3.1/dist/purify.min.js"></script>
</head>

<body>
    <h1>Impossible Puzzle</h1>
    <p>Enter two strings A and B. If they are equal in content but different in length, you will get the flag!</p>
    <form method="post">
        <label for="A">A:</label>
        <input type="text" id="A" name="A" required>
        <label for="B">B:</label>
        <input type="text" id="B" name="B" required>
        <button type="submit">Submit</button>
    </form>
</body>
</html>
```

---

##  Mục tiêu | Goal

**🇻🇳:**
- Làm cho `A == B` nhưng `strlen(A) != strlen(B)`


**🇬🇧:**
- Make `A == B` but `strlen(A) != strlen(B)`

---

##  Ý tưởng chính | Key Idea

**🇻🇳:**  
[Tóm tắt ý tưởng giải bài trong 1–2 dòng]

**🇬🇧:**  
[Summarize the solving idea in 1–2 lines]

---

##  Phân tích | Analysis

### 1. Quan sát ban đầu | Initial Observation

**🇻🇳:**
- đọc qua src code thì thấy chỗ so sách $A == $B trong PHP có 2 kiểu so sánh.
==	so sánh lỏng (loose)
===	so sánh chặt (strict) 


**🇬🇧:**
- Read src code then can see $A == $B in PHP have two type compare.
==	so sánh lỏng (loose)
===	so sánh chặt (strict) 

---

### 2. Phân tích chi tiết | Deep Analysis

**🇻🇳:**
Vấn đề: Loose Comparison
`$A == $B` thì PHP sẽ:
-Tự động ép kiểu (type juggling)
-Nếu có số → convert về number rồi so sánh
**🇬🇧:**
- Problem: Loose Comparison
- `$A == $B` in PHP will:
- -Automatically type (juggle typing)
- If there is a number → convert to number and then compare

---

### 3. Lỗ hổng | Vulnerability

**🇻🇳:**
- Loại lỗ hổng: [SQLi / XSS / IDOR / Logic bug / Crypto / ...]
- Nguyên nhân:
  - Đây là lỗi xảy ra khi:
  - Sử dụng toán tử == trong PHP
  - PHP tự động ép kiểu dữ liệu (type coercion)
  - Dẫn đến so sánh sai logic
**🇬🇧:**
- Vulnerability type: Type Juggling (Loose Comparison Vulnerability)
- Root cause:
  - This vulnerability occurs when:
  - Using == in PHP
  - PHP performs automatic type coercion
  - Leading to incorrect comparisons

---

##  Khai thác | Exploitation

### Payload / Attack

```text
Chỉ đơn giản nhập A = number random, B = A + 'space' 
For example: A = '12' , B = '12 ' space is special
```
=======
#  Challenge: Impossible Puzzle

- **Category:** [ Web ]
- **Difficulty:** [Easy ]
- **Author:** 
- **Platform:** https://alpacahack.com/daily/challenges/impossible-puzzle?month=2026-04

---

##  Mô tả | Description

**🇻🇳 Tiếng Việt:**  
Hãy nhập 2 chuỗi A và B. Nếu nó bằng nhau về nội dung nhưng khác nhau trong độ dài, thì sẽ lấy được flag!

**🇬🇧 English:**  
Enter two strings A and B. If they are equal in content but different in length, you will get the flag!

---

## Code
```
<?php

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $A = $_POST['A'] ?? '';
    $B = $_POST['B'] ?? '';

    // type check
    if (!is_string($A) || !is_string($B)) {
        die('Invalid input');
    }
    // check
    if (strlen($A) != strlen($B) && $A == $B){
        echo "<blockquote>Congratulations! Here is your flag:\n" . getenv('FLAG') . "</blockquote>";
    }
    else {
        echo "<blockquote>Try again!</blockquote>";
    }
}

?>

<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8" />
    <title>Impossible Puzzle</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://unpkg.com/sakura.css/css/sakura.css" type="text/css" />
    <script src="https://cdn.jsdelivr.net/npm/dompurify@3.3.1/dist/purify.min.js"></script>
</head>

<body>
    <h1>Impossible Puzzle</h1>
    <p>Enter two strings A and B. If they are equal in content but different in length, you will get the flag!</p>
    <form method="post">
        <label for="A">A:</label>
        <input type="text" id="A" name="A" required>
        <label for="B">B:</label>
        <input type="text" id="B" name="B" required>
        <button type="submit">Submit</button>
    </form>
</body>
</html>
```

---

##  Mục tiêu | Goal

**🇻🇳:**
- Làm cho `A == B` nhưng `strlen(A) != strlen(B)`


**🇬🇧:**
- Make `A == B` but `strlen(A) != strlen(B)`

---

##  Ý tưởng chính | Key Idea

**🇻🇳:**  
[Tóm tắt ý tưởng giải bài trong 1–2 dòng]

**🇬🇧:**  
[Summarize the solving idea in 1–2 lines]

---

##  Phân tích | Analysis

### 1. Quan sát ban đầu | Initial Observation

**🇻🇳:**
- đọc qua src code thì thấy chỗ so sách $A == $B trong PHP có 2 kiểu so sánh.
==	so sánh lỏng (loose)
===	so sánh chặt (strict) 


**🇬🇧:**
- Read src code then can see $A == $B in PHP have two type compare.
==	so sánh lỏng (loose)
===	so sánh chặt (strict) 

---

### 2. Phân tích chi tiết | Deep Analysis

**🇻🇳:**
Vấn đề: Loose Comparison
`$A == $B` thì PHP sẽ:
-Tự động ép kiểu (type juggling)
-Nếu có số → convert về number rồi so sánh
**🇬🇧:**
- Problem: Loose Comparison
- `$A == $B` in PHP will:
- -Automatically type (juggle typing)
- If there is a number → convert to number and then compare

---

### 3. Lỗ hổng | Vulnerability

**🇻🇳:**
- Loại lỗ hổng: [SQLi / XSS / IDOR / Logic bug / Crypto / ...]
- Nguyên nhân:
  - Đây là lỗi xảy ra khi:
  - Sử dụng toán tử == trong PHP
  - PHP tự động ép kiểu dữ liệu (type coercion)
  - Dẫn đến so sánh sai logic
**🇬🇧:**
- Vulnerability type: Type Juggling (Loose Comparison Vulnerability)
- Root cause:
  - This vulnerability occurs when:
  - Using == in PHP
  - PHP performs automatic type coercion
  - Leading to incorrect comparisons

---

##  Khai thác | Exploitation

### Payload / Attack

```text
Chỉ đơn giản nhập A = number random, B = A + 'space' 
For example: A = '12' , B = '12 ' space is special
```

>>>>>>> cc59772 (Writeup Impossible Puzzle)
## FLAG: Alpaca{L00se_c0mpar1sons_1n_php_mak3s_unexp3cted_behavi0r}