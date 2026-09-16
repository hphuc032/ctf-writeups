import sys
sys.path.insert(0, r".\_emu")

from unicorn import Uc, UC_ARCH_X86, UC_MODE_64, UC_HOOK_CODE, UcError
from unicorn.x86_const import *

BIN = r"C:\Users\Phuc\Downloads\chall"
BASE = 0x400000
MAIN = 0x402F85
STACK_BASE = 0x900000
STACK_SIZE = 0x20000
INPUT = 0x800100
SENTINEL = 0xDEAD0000

# Static libc routines called directly by main.
PUTS = 0x40C2C0
PRINTF = 0x406410
FGETS = 0x40BF50
FFLUSH = 0x40BDD0
STRCSPN_PLT = 0x4010A8
STRLEN_PLT = 0x4010B8
MEMCMP_PLT = 0x401068
MEMCPY_PLT = 0x401030


def cstr(u, ptr, limit=512):
    out = bytearray()
    for i in range(limit):
        b = bytes(u.mem_read(ptr + i, 1))[0]
        if b == 0:
            break
        out.append(b)
    return bytes(out)


def fake_return(u, value=0):
    rsp = u.reg_read(UC_X86_REG_RSP)
    ret = int.from_bytes(u.mem_read(rsp, 8), "little")
    u.reg_write(UC_X86_REG_RSP, rsp + 8)
    u.reg_write(UC_X86_REG_RAX, value)
    u.reg_write(UC_X86_REG_RIP, ret)


def run(candidate, trace=False):
    image = open(BIN, "rb").read()
    u = Uc(UC_ARCH_X86, UC_MODE_64)
    # Includes the file image and the program's BSS globals near 0x4ae000.
    u.mem_map(BASE, 0xD0000, 7)
    u.mem_write(BASE, image)
    u.mem_map(0x800000, 0x10000, 7)
    u.mem_map(STACK_BASE - STACK_SIZE, STACK_SIZE, 7)
    u.mem_map(SENTINEL, 0x1000, 7)

    rsp = STACK_BASE - 0x100
    u.mem_write(rsp, SENTINEL.to_bytes(8, "little"))
    u.reg_write(UC_X86_REG_RSP, rsp)
    u.reg_write(UC_X86_REG_RDI, 1)
    u.reg_write(UC_X86_REG_RSI, 0)
    u.reg_write(UC_X86_REG_RDX, 0)

    result = {"output": [], "validator": None, "core": None, "error": None}

    def hook(uc, address, size, _):
        if address == SENTINEL:
            result["exit"] = uc.reg_read(UC_X86_REG_RAX)
            uc.emu_stop()
            return
        if address in (PUTS, PRINTF):
            result["output"].append(cstr(uc, uc.reg_read(UC_X86_REG_RDI)))
            fake_return(uc, 0)
            return
        if address == FFLUSH:
            fake_return(uc, 0)
            return
        if address == FGETS:
            dst = uc.reg_read(UC_X86_REG_RDI)
            n = uc.reg_read(UC_X86_REG_RSI)
            supplied = candidate + b"\n"
            supplied = supplied[: max(0, n - 1)] + b"\0"
            uc.mem_write(dst, supplied)
            fake_return(uc, dst)
            return
        if address == STRCSPN_PLT:
            text = cstr(uc, uc.reg_read(UC_X86_REG_RDI))
            reject = set(cstr(uc, uc.reg_read(UC_X86_REG_RSI)))
            pos = next((i for i, ch in enumerate(text) if ch in reject), len(text))
            fake_return(uc, pos)
            return
        if address == STRLEN_PLT:
            fake_return(uc, len(cstr(uc, uc.reg_read(UC_X86_REG_RDI))))
            return
        if address == MEMCMP_PLT:
            left = bytes(uc.mem_read(uc.reg_read(UC_X86_REG_RDI), uc.reg_read(UC_X86_REG_RDX)))
            right = bytes(uc.mem_read(uc.reg_read(UC_X86_REG_RSI), uc.reg_read(UC_X86_REG_RDX)))
            fake_return(uc, 0 if left == right else (-1 if left < right else 1) & ((1 << 64) - 1))
            return
        if address == MEMCPY_PLT:
            dst, src, count = (uc.reg_read(UC_X86_REG_RDI), uc.reg_read(UC_X86_REG_RSI), uc.reg_read(UC_X86_REG_RDX))
            uc.mem_write(dst, bytes(uc.mem_read(src, count)))
            fake_return(uc, dst)
            return
        if address == 0x402983:
            result["validator_input"] = cstr(uc, uc.reg_read(UC_X86_REG_RDI))
        if address == 0x402A1B:  # final result, immediately before leave
            result["validator"] = uc.reg_read(UC_X86_REG_RAX) & 0xFFFFFFFF
        if address == 0x401CC7:
            result["core"] = uc.reg_read(UC_X86_REG_RAX) & 0xFFFFFFFF
        if address == 0x401D4C:
            result["wrapper"] = uc.reg_read(UC_X86_REG_RAX) & 0xFFFFFFFF
        if trace and 0x402F85 <= address <= 0x4033A0:
            pass

    u.hook_add(UC_HOOK_CODE, hook)
    try:
        u.emu_start(MAIN, SENTINEL + 1, timeout=30_000_000, count=50_000_000)
    except UcError as e:
        bad_rsp = u.reg_read(UC_X86_REG_RSP)
        caller = int.from_bytes(u.mem_read(bad_rsp, 8), "little")
        result["error"] = f"{e}; rip={u.reg_read(UC_X86_REG_RIP):#x}; rsp={bad_rsp:#x}; return-to={caller:#x}"
    result["g_b0"] = int.from_bytes(u.mem_read(0x4AE3B0, 4), "little")
    result["g_b4"] = int.from_bytes(u.mem_read(0x4AE3B4, 4), "little")
    return result


if __name__ == "__main__":
    tests = sys.argv[1:] or ["UTECTF{" + "A" * 21 + "}", "UTECTF{" + "0" * 21 + "}"]
    for test in tests:
        print(test, run(test.encode()))
