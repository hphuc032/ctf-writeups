import sys
sys.path.insert(0, '.\\_angr')
import z3
from pathlib import Path
from decode_vm import key

blob = Path(r"C:\Users\Phuc\Downloads\chall").read_bytes()
program = blob[0x7b220:0x7b220 + 0x600]
table = blob[0x7b020:0x7b020 + 0x400]

def dec(memory, index, seed):
    return memory[index] ^ key(index, seed)

def ins(pc):
    pos = pc * 5
    return [dec(program, pos + i, 0x46) for i in range(5)]

# The table lookup is a decoded 512-byte lookup table.  Keep it as a Z3 array
# so the transformed byte can remain symbolic.
sbox = z3.K(z3.BitVecSort(16), z3.BitVecVal(0, 8))
for index in range(512):
    sbox = z3.Store(sbox, z3.BitVecVal(index, 16), z3.BitVecVal(dec(table, index, 0x5b), 8))

original = [z3.BitVec(f'c{i}', 8) for i in range(21)]
v = original[:]
solver = z3.Solver()

pc = 0
checks = 0
while True:
    op, a, b, lo, hi = ins(pc)
    target = lo | (hi << 8)
    if op == 0xff:
        break
    if op == 1:
        v[a], v[b] = v[b], v[a]
        pc += 1
    elif op == 2:
        v[a] = v[a] ^ z3.BitVecVal(b, 8)
        pc += 1
    elif op == 3:
        ix = z3.ZeroExt(8, v[a]) + z3.BitVecVal(b << 8, 16)
        v[a] = z3.Select(sbox, ix)
        pc += 1
    elif op == 4:
        v[a] = z3.RotateLeft(v[a], b & 7)
        pc += 1
    elif op == 5:
        shift, expected = (b >> 1) & 7, b & 1
        solver.add(z3.Extract(shift, shift, v[a]) == expected)
        checks += 1
        pc += 1
    elif op == 6:
        pc = target
    elif op == 7:
        # The successful route stores 1; the failure route is excluded by the
        # constraints above, so only record it here.
        pc += 1
    elif op == 8:
        v[a] = v[a] ^ v[b]
        pc += 1
    elif op == 9:
        v[a] = v[a] + v[b]
        pc += 1
    else:
        raise RuntimeError(f'unknown opcode {op:#x} at {pc}')

print('constraints', checks, 'pc', pc)
if solver.check() != z3.sat:
    raise SystemExit('unsat')
m = solver.model()
body = bytes(m.eval(x, model_completion=True).as_long() for x in original)
print('body hex:', body.hex())
print('flag:', b'UTECTF{' + body + b'}')
print('printable:', ''.join(chr(x) if 32 <= x < 127 else '.' for x in body))
