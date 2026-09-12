# B1tsy Ducky Writeup

## Overview

Challenge la mot game Bitsy chay tren client-side tai:

```text
https://b1tsy.v1t.site/game.html
```

Trang index chi co nut `Play`, con logic chinh nam trong `game.html`.

Trong source cua `game.html`, game data duoc nhung trong:

```html
<script type="text/bitsyGameData" id="exportedGameData">
```

Game noi:

```text
Talk to the duck to find the flag.
```

## Game Data Analysis

Trong Bitsy data co 3 con duck:

```text
SPR a
NAME v1t
DLG 2
POS 0 8,7

SPR b
DLG 3
POS 2 8,7

SPR c
DLG 5
POS 3 14,1
```

Hai con duck dau chi noi khong co flag:

```text
But i do not have the flag
You could ask the other duck
```

Duck dac biet la sprite `c`, nam o room `3`, vi tri `(14,1)`.

Dialog cua duck nay co tag dac biet:

```text
DLG 5
"""
How you find me quack quack
(duck)
"""
```

Tag `(duck)` duoc custom JavaScript hook lai.

## JavaScript Hook

Cuoi trang co script custom:

```js
var specialDuckSpriteId = "c";

Object.defineProperty(window, "__bdx_17a", {
  value: function () {
    if (!isPlayerTalkingToSpecialDuck()) {
      alert("quack");
      return;
    }

    window.__duckWasmReady.then(function () {
      var room3Block = serializeRoomBlock("3");
      var referrer = document.referrer || "";
      var picked32 = pick32();

      var flag_decrypt = window.duckWasmReveal(referrer, room3Block, picked32);
      ...
      window.flag = flag_decrypt;
      window.close();
    });
  }
});
```

Dieu kien de goi decrypt:

- Vua noi chuyen voi sprite `c`.
- Player dung canh sprite `c`.
- Dialog dang active.
- `main.wasm` da load va export `duckWasmReveal`.

## Important Parameters

Ham decrypt nhan 3 tham so:

```js
duckWasmReveal(referrer, room3Block, picked32)
```

Trong do:

```js
referrer = document.referrer
room3Block = serializeRoomBlock("3")
picked32 = pick32()
```

`pick32()` lay chuoi hex 32 ky tu trong script attributes. Gia tri tren remote:

```text
797084dac2504482bcfaec15adc048bb
```

Luu y: phai mo game tu trang index bang nut `Play`, de:

```js
document.referrer
```

la:

```text
https://b1tsy.v1t.site/
```

Neu mo thang `/game.html`, referrer se sai va decrypt fail.

## Triggering The Hidden Duck

Duck `c` bi dat o vi tri kho/khong the toi bang gameplay binh thuong. Co the dung Console de dat player dung canh duck:

```js
window.close = () => alert(window.flag);

player().room = "3";
player().x = 14;
player().y = 2;

sprite.c.room = "3";
sprite.c.x = 14;
sprite.c.y = 1;

startSpriteDialog("c");

setTimeout(() => {
  window.__bdx_17a();
  console.log(window.flag);
}, 300);
```

Neu referrer dung, script se goi WASM decrypt.

## WASM Reverse

Tai `main.wasm` ve va tim strings thay cac dau vet:

```text
duckWasmReveal
b1tsy-ducky-aesgcm
some thing go wrong go to start again
```

Sau khi disassemble WASM, ham `duckWasmReveal` ghep key string nhu sau:

```text
referrer + "|" + room3Block + "|" + picked32
```

Encrypted hex trong WASM:

```text
9e8c2b395bbf6bd7434230ab998c6e86f3228c503324c8660715ccd0bc74deb7d6346dfcc4a9614e58cb
```

Thuat toan decrypt:

```js
keyString = referrer + "|" + room3Block + "|" + picked32
key = HMAC_SHA256("b1tsy-ducky-aesgcm", keyString)
nonce = SHA256("nonce|" + keyString).slice(0, 12)
plaintext = AES_256_GCM_DECRYPT(ciphertext, key, nonce)
```

Voi:

```text
referrer = https://b1tsy.v1t.site/
picked32 = 797084dac2504482bcfaec15adc048bb
```

decrypt ra flag.

## Flag

```text
v1t{b1tsy_t1psy_duck_w4sm}
```

