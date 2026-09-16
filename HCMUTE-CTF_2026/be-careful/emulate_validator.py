import sys
sys.path.insert(0, r".\_emu")
from unicorn import Uc, UC_ARCH_X86, UC_MODE_64, UC_HOOK_CODE, UcError
from unicorn.x86_const import *

BIN = r"C:\Users\Phuc\Downloads\chall"
BASE = 0x400000
RET = 0xDEAD0000
STACK = 0x900000

def run(body, junk_ptr=0x800000, mutate_expected=False):
    data = open(BIN, 'rb').read()
    u = Uc(UC_ARCH_X86, UC_MODE_64)
    size = (len(data)+0xfff)&~0xfff
    u.mem_map(BASE, size, 7)
    u.mem_write(BASE, data)
    u.mem_map(0x800000, 0x10000, 7)
    u.mem_map(STACK-0x10000, 0x10000, 7)
    u.mem_map(RET & ~0xfff, 0x1000, 7)
    # input and temporary memory
    inp = 0x800100
    u.mem_write(inp, body + b'\x00' * 0x1000)
    expected = BASE + (0x47b220-0x400000)
    table = BASE + (0x47b020-0x400000)
    if mutate_expected:
        u.mem_write(expected, bytes((i * 37 + 11) & 255 for i in range(248)))
    # Fill stack to make the otherwise-uninitialized local pointer explicit.
    u.mem_write(STACK-0x10000, (junk_ptr).to_bytes(8, 'little') * (0x10000//8))
    u.reg_write(UC_X86_REG_RSP, STACK-8)
    u.mem_write(STACK-8, RET.to_bytes(8,'little'))
    u.reg_write(UC_X86_REG_RDI, expected)
    u.reg_write(UC_X86_REG_RSI, 0xf8)
    u.reg_write(UC_X86_REG_RDX, 0x46)
    u.reg_write(UC_X86_REG_RCX, table)
    u.reg_write(UC_X86_REG_R8, inp)
    result = {'ret':None, 'error':None, 'hits':0}
    def hook(uc, address, size, user):
        if address in (0x401d12, 0x401971, 0x402522):
            result['hits'] += 1
        if address == RET:
            result['ret'] = uc.reg_read(UC_X86_REG_RAX)
            uc.emu_stop()
    u.hook_add(UC_HOOK_CODE, hook)
    try:
        # Main's first state hashes the literal `static_path_only` before the
        # flag validator is reached; reproduce that constructor/state update.
        u.reg_write(UC_X86_REG_RSP, STACK-8)
        u.mem_write(STACK-8, RET.to_bytes(8,'little'))
        u.reg_write(UC_X86_REG_RDI, BASE + (0x47bce4-0x400000))
        u.emu_start(0x402522, RET + 1, timeout=0, count=0)
        init_ret = u.reg_read(UC_X86_REG_RAX)
        init_global = int.from_bytes(u.mem_read(BASE + (0x4ae3b0-0x400000), 4), 'little')
        u.reg_write(UC_X86_REG_RSP, STACK-8)
        u.mem_write(STACK-8, RET.to_bytes(8,'little'))
        u.reg_write(UC_X86_REG_RDI, expected)
        u.reg_write(UC_X86_REG_RSI, 0xf8)
        u.reg_write(UC_X86_REG_RDX, 0x46)
        u.reg_write(UC_X86_REG_RCX, table)
        u.reg_write(UC_X86_REG_R8, inp)
        u.emu_start(0x401d12, RET + 1, timeout=0, count=0)
        result['init_ret'] = init_ret
        result['init_global'] = init_global
    except UcError as e:
        result['error'] = str(e) + f" rip={u.reg_read(UC_X86_REG_RIP):x} rsp={u.reg_read(UC_X86_REG_RSP):x}"
    return result

if __name__ == '__main__':
    for b in [b'A'*21, b'0'*21, b'UTECTF{'+b'A'*21+b'}']:
        print(b, run(b))
