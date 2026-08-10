static void finish(unsigned code) {
    register unsigned address = 0x0002fffdu;
    __asm__ volatile ("sw %0, 0(%1)" :: "r"(code), "r"(address) : "memory");
    for (;;) {
    }
}

static unsigned multiply_high_signed(int lhs, int rhs) {
    unsigned result;
    __asm__ volatile ("mulh %0, %1, %2" : "=r"(result) : "r"(lhs), "r"(rhs));
    return result;
}

static unsigned multiply_high_signed_unsigned(int lhs, unsigned rhs) {
    unsigned result;
    __asm__ volatile ("mulhsu %0, %1, %2" : "=r"(result) : "r"(lhs), "r"(rhs));
    return result;
}

static unsigned multiply_high_unsigned(unsigned lhs, unsigned rhs) {
    unsigned result;
    __asm__ volatile ("mulhu %0, %1, %2" : "=r"(result) : "r"(lhs), "r"(rhs));
    return result;
}

int main(void) {
    volatile int lhs = -12345;
    volatile int rhs = 6789;
    volatile unsigned unsigned_lhs = 0xfedcba98u;
    volatile unsigned unsigned_rhs = 0x89abcdefu;
    volatile int sum = 0;
    int i;

    if (lhs * rhs != -83810205)
        finish((unsigned)(lhs * rhs));
    if (multiply_high_signed(lhs, rhs) != 0xffffffffu)
        finish(0xdead0011u);
    if (multiply_high_signed_unsigned(lhs, unsigned_rhs) != 0xffffe611u)
        finish(0xdead0012u);
    if (multiply_high_unsigned(unsigned_lhs, unsigned_rhs) != 0x890f2a50u)
        finish(0xdead0013u);

    for (i = 0; i < 200; i++) {
        if ((i & 7) != 0)
            sum += i;
        else
            sum -= i;
    }

    finish(sum == 15100 ? 0xc0de : 0xdead0002u);
    return 0;
}
