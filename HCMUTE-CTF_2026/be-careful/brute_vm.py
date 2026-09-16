from pathlib import Path

raw = Path(r"C:\Users\Phuc\Downloads\chall").read_bytes()
prog = raw[0x7b220:0x7b220 + 0x600]
tab = raw[0x7b020:0x7b020 + 0x400]

def key(index, seed):
    value = seed ^ 0xA7
    for i in range(index + 1):
        value = ((value * 73 + i + 0x29) ^ (value >> 3)) & 0xff
    return value

def dec(mem, pos, seed): return mem[pos] ^ key(pos, seed)
def ins(pc): return [dec(prog, pc * 5 + i, 0x46) for i in range(5)]

# The 96 operations before the bit checks are all reversible.
ops = [ins(pc) for pc in range(96)]
checks = [ins(pc) for pc in range(96, 243)]

need = [0] * 21
mask = [0] * 21
for op, a, b, lo, hi in checks:
    assert op == 5
    bit, wanted = (b >> 1) & 7, b & 1
    mask[a] |= 1 << bit
    need[a] |= wanted << bit
print('final masks:', [f'{x:02x}' for x in mask])
print('final low bits:', [f'{x:02x}' for x in need])
free_bit = [next(bit for bit in range(8) if not (mask[i] & (1 << bit))) for i in range(21)]

# Decode lookup pages and build their inverse maps.
pages = []
for page in range(2):
    forward = [dec(tab, page * 256 + x, 0x5b) for x in range(256)]
    inverse = [-1] * 256
    for x, y in enumerate(forward):
        if inverse[y] != -1:
            raise RuntimeError('non-bijective lookup page')
        inverse[y] = x
    pages.append(inverse)

def ror8(x, n):
    n &= 7
    return ((x >> n) | (x << (8 - n))) & 0xff

def reconstruct(bits):
    v = [need[i] | (((bits >> i) & 1) << free_bit[i]) for i in range(21)]
    # Invert cross-byte stage.
    for op, a, b, lo, hi in reversed(ops):
        if op == 8:
            v[a] ^= v[b]
        elif op == 9:
            v[a] = (v[a] - v[b]) & 0xff
        elif op in (1, 2, 3, 4):
            continue
        else:
            raise RuntimeError((op, a, b))
    # Invert individual transforms (rotate, table lookup, xor) in reverse.
    for op, a, b, lo, hi in reversed(ops):
        if op == 4:
            v[a] = ror8(v[a], b)
        elif op == 3:
            v[a] = pages[b][v[a]]
        elif op == 2:
            v[a] ^= b
    # Invert the initial swaps.
    for op, a, b, lo, hi in reversed(ops):
        if op == 1:
            v[a], v[b] = v[b], v[a]
    return bytes(v)

solutions = []
for bits in range(1 << 21):
    body = reconstruct(bits)
    if all(0x20 <= ch <= 0x7e for ch in body):
        solutions.append(body)
        print(b'UTECTF{' + body + b'}')
print('printable solutions:', len(solutions))
