from pathlib import Path

raw = Path(r"C:\Users\Phuc\Downloads\chall").read_bytes()
def key(index, seed):
    v = seed ^ 0xa7
    for i in range(index + 1):
        v = ((v * 73 + i + 0x29) ^ (v >> 3)) & 255
    return v
def d(pos): return raw[0x7b700 + pos] ^ key(pos, 0x52)
for pc in range(284):
    x = [d(pc * 5 + i) for i in range(5)]
    print(f'{pc:03d}: ' + ' '.join(f'{v:02x}' for v in x))
    if x[0] == 0xff: break
