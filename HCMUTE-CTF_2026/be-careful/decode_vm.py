from pathlib import Path

data = Path(r"C:\Users\Phuc\Downloads\chall").read_bytes()

def key(index, seed):
    value = seed ^ 0xA7
    for i in range(index + 1):
        value = ((value * 73 + i + 0x29) ^ (value >> 3)) & 0xff
    return value

def dec(blob, index, seed):
    return blob[index] ^ key(index, seed)

program = data[0x7b220:0x7b220+0x600]
for pos in range(0, 0x4d8, 5):
    ins = [dec(program, pos + n, 0x46) for n in range(5)]
    print(f"{pos:03d}: " + " ".join(f"{x:02x}" for x in ins))
    if ins[0] == 0xff:
        break
