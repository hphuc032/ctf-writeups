from pathlib import Path
import hashlib
import itertools
import sqlite3
import subprocess
import sys


VAULT = Path(r"VerySecureVault_extracted\App\MyDearPasswordProtector.db.ecdh")
OPENSSL = Path(r"C:\Users\Phuc\Anaconda3\Library\bin\openssl.exe")


def hex_ascii(n):
    return ord("0123456789abcdef"[n])


def recover_xor_key(cipher):
    # plaintext[i] is the i-th character of key.hex(), while encryption is
    # cipher[i] = plaintext[i] XOR key[i % 32].
    constraints = []
    for i in range(64):
        src = i // 2
        dst = i % 32
        shift = 4 if i % 2 == 0 else 0
        pairs = {(s, cipher[i] ^ hex_ascii((s >> shift) & 15)) for s in range(256)}
        constraints.append((src, dst, pairs))

    domains = [set(range(256)) for _ in range(32)]

    def propagate(ds):
        changed = True
        while changed:
            changed = False
            for src, dst, pairs in constraints:
                allowed_s = {s for s, d in pairs if s in ds[src] and d in ds[dst]}
                allowed_d = {d for s, d in pairs if s in ds[src] and d in ds[dst]}
                if not allowed_s or not allowed_d:
                    return False
                if allowed_s != ds[src]:
                    ds[src] = allowed_s
                    changed = True
                if allowed_d != ds[dst]:
                    ds[dst] = allowed_d
                    changed = True
        return True

    solutions = []

    def search(ds):
        if not propagate(ds):
            return
        unresolved = [i for i, d in enumerate(ds) if len(d) > 1]
        if not unresolved:
            key = bytes(next(iter(d)) for d in ds)
            plain = bytes(b ^ key[i % 32] for i, b in enumerate(cipher))
            if plain[:64] == key.hex().encode() and plain.count(b" | ", 0, 100) >= 1:
                solutions.append((key, plain))
            return
        idx = min(unresolved, key=lambda i: len(ds[i]))
        for value in sorted(ds[idx]):
            nxt = [set(d) for d in ds]
            nxt[idx] = {value}
            search(nxt)

    search(domains)
    return solutions


# NIST P-256 / secp256r1 parameters used by Bouncy Castle's SecNamedCurves.
P = 0xFFFFFFFF00000001000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF
A = P - 3
B = 0x5AC635D8AA3A93E7B3EBBD55769886BC651D06B0CC53B0F63BCE3C3E27D2604B
GX = 0x6B17D1F2E12C4247F8BCE6E563A440F277037D812DEB33A0F4A13945D898C296
GY = 0x4FE342E2FE1A7F9B8EE7EB4A7C0F9E162BCE33576B315ECECBB6406837BF51F5
N = 0xFFFFFFFF00000000FFFFFFFFFFFFFFFFBCE6FAADA7179E84F3B9CAC2FC632551


def point_add(p1, p2):
    if p1 is None:
        return p2
    if p2 is None:
        return p1
    x1, y1 = p1
    x2, y2 = p2
    if x1 == x2 and (y1 + y2) % P == 0:
        return None
    if p1 == p2:
        slope = (3 * x1 * x1 + A) * pow(2 * y1, -1, P) % P
    else:
        slope = (y2 - y1) * pow(x2 - x1, -1, P) % P
    x3 = (slope * slope - x1 - x2) % P
    y3 = (slope * (x1 - x3) - y1) % P
    return x3, y3


def point_mul(k, point=(GX, GY)):
    result = None
    addend = point
    while k:
        if k & 1:
            result = point_add(result, addend)
        addend = point_add(addend, addend)
        k >>= 1
    return result


def generate_key_iv(password_hash_hex, timestamp):
    d1 = int.from_bytes(hashlib.sha256(password_hash_hex.encode()).digest(), "big") % N
    d2 = int.from_bytes(hashlib.sha256(timestamp.encode()).digest(), "big") % N
    x, _ = point_mul((d1 * d2) % N)
    material = hashlib.sha512(x.to_bytes(32, "big")).digest()
    return material[:32], material[32:48]


def main():
    cipher = VAULT.read_bytes()
    sols = recover_xor_key(cipher)
    print("solutions:", len(sols))
    for key, plain in sols:
        print("key:", key.hex())
        parts = plain.decode("latin1").split(" | ")
        print("stored hash:", parts[0])
        print("timestamp:", parts[-1])
        print("ciphertext hex length:", len(parts[1]))
        Path("vault_wrapper_decrypted.txt").write_bytes(plain)
        aes_key, iv = generate_key_iv(parts[0], parts[2])
        print("aes key:", aes_key.hex())
        print("aes iv:", iv.hex())
        encrypted = Path("vault_sqlite.encrypted.bin")
        decrypted = Path("vault_decrypted.sqlite")
        encrypted.write_bytes(bytes.fromhex(parts[1]))
        subprocess.run(
            [str(OPENSSL), "enc", "-d", "-aes-256-cbc", "-K", aes_key.hex(), "-iv", iv.hex(),
             "-in", str(encrypted), "-out", str(decrypted)],
            check=True,
        )
        print("sqlite header:", decrypted.read_bytes()[:16])
        with sqlite3.connect(decrypted) as db:
            rows = db.execute("SELECT UUID, Title, Username, Password, URL, Notes, LastModified, Tags, CreationTime FROM entries").fetchall()
        for row in rows:
            print("ROW:", row)


if __name__ == "__main__":
    main()
