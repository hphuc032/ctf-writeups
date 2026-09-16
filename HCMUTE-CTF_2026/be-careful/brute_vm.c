#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

static uint8_t raw[0xc76c0];
static uint8_t inv[2][256];
static uint8_t code[284][5];

static uint8_t key(unsigned index, uint8_t seed) {
    unsigned v = seed ^ 0xa7;
    for (unsigned i = 0; i <= index; ++i)
        v = ((v * 73 + i + 0x29) ^ (v >> 3)) & 255;
    return (uint8_t)v;
}
static uint8_t dec(uint32_t base, unsigned index, uint8_t seed) {
    return raw[base + index] ^ key(index, seed);
}
static void getins(unsigned pc, uint8_t x[5]) {
    for (unsigned i = 0; i < 5; ++i) x[i] = dec(0x7b700, pc * 5 + i, 0x52);
}
static uint8_t ror8(uint8_t x, unsigned n) {
    n &= 7; return (x >> n) | (x << ((8 - n) & 7));
}
int main(void) {
    FILE *f = fopen("C:\\Users\\Phuc\\Downloads\\chall", "rb");
    if (!f || fread(raw, 1, sizeof raw, f) != sizeof raw) return 2;
    uint8_t need[21] = {0}, mask[21] = {0}, freebit[21];
    uint8_t x[5];
    for (unsigned p = 0; p < 284; ++p)
        for (unsigned i = 0; i < 5; ++i) code[p][i] = dec(0x7b700, p * 5 + i, 0x52);
    for (unsigned p = 111; p < 279; ++p) {
        for (unsigned i = 0; i < 5; ++i) x[i] = code[p][i];
        unsigned bit = (x[2] >> 1) & 7;
        mask[x[1]] |= 1u << bit;
        need[x[1]] |= (x[2] & 1) << bit;
    }
    for (unsigned i = 0; i < 21; ++i)
        for (unsigned b = 0; b < 8; ++b) if (!(mask[i] & (1u << b))) freebit[i] = b;
    for (unsigned page = 0; page < 2; ++page)
        for (unsigned i = 0; i < 256; ++i) inv[page][dec(0x7b020, page * 256 + i, 0x5b)] = i;

    unsigned found = 0;
    for (uint32_t bits = 0; bits < 1; ++bits) {
        uint8_t v[21];
        for (unsigned i = 0; i < 21; ++i) v[i] = need[i];
        for (int p = 110; p >= 83; --p) {
            uint8_t *x = code[p];
            if (x[0] == 8) v[x[1]] ^= v[x[2]];
            if (x[0] == 9) v[x[1]] -= v[x[2]];
        }
        for (int p = 82; p >= 20; --p) {
            uint8_t *x = code[p];
            if (x[0] == 4) v[x[1]] = ror8(v[x[1]], x[2]);
            if (x[0] == 3) v[x[1]] = inv[x[2]][v[x[1]]];
            if (x[0] == 2) v[x[1]] ^= x[2];
        }
        for (int p = 19; p >= 0; --p) {
            uint8_t *x = code[p];
            uint8_t t = v[x[1]]; v[x[1]] = v[x[2]]; v[x[2]] = t;
        }
        int ok = 1;
        for (unsigned i = 0; i < 21; ++i) if (v[i] < 0x20 || v[i] > 0x7e) ok = 0;
        if (ok) {
            printf("UTECTF{"); fwrite(v, 1, 21, stdout); puts("}");
            ++found;
        }
    }
    fprintf(stderr, "found=%u\n", found);
    return 0;
}
