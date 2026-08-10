#define WORDS 4096

static volatile unsigned working_set[WORDS];

static void finish(unsigned code) {
    register unsigned address = 0x0002fffdu;
    __asm__ volatile ("sw %0, 0(%1)" :: "r"(code), "r"(address) : "memory");
    for (;;) {
    }
}

static unsigned pattern(unsigned index) {
    return (index * 0x9e3779b9u) ^ (index << 16) ^ 0xa5a55a5au;
}

int main(void) {
    unsigned checksum = 0;
    unsigned index;

    // This 16 KiB working set is twice the 8 KiB two-way D-cache capacity.
    // The second pass must therefore observe data restored after dirty eviction.
    for (index = 0; index < WORDS; index++)
        working_set[index] = pattern(index);

    for (index = 0; index < WORDS; index++) {
        unsigned value = working_set[index];
        if (value != pattern(index))
            finish(0xdead1000u | (index & 0xfffu));
        checksum ^= value;
    }

    finish(checksum == 0x726ac000u ? 0xc0deu : checksum);
    return 0;
}
