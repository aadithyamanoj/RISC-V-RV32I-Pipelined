#include "libmc.h"

#define N 16
#define ELEMENTS (N * N)

static signed char x[ELEMENTS];
static signed char wq[ELEMENTS];
static signed char wk[ELEMENTS];
static signed char wv[ELEMENTS];
static signed char q[ELEMENTS];
static signed char k[ELEMENTS];
static signed char v[ELEMENTS];
static signed char kt[ELEMENTS];
static signed char scores[ELEMENTS];
static signed char probabilities[ELEMENTS];
static signed char output[ELEMENTS];

static unsigned random_state = 1592594996u;

static unsigned random_integer(unsigned span) {
    random_state = 1664525u * random_state + 1013904223u;
    return random_state % span;
}

static signed char random_signed_unit(void) {
    return (signed char)((int)random_integer(3) - 1);
}

static void generate_dense(signed char *matrix) {
    int i;
    for (i = 0; i < ELEMENTS; i++)
        matrix[i] = random_signed_unit();
}

static void generate_sparse_projection(signed char *matrix) {
    int column;
    int row;
    for (row = 0; row < ELEMENTS; row++)
        matrix[row] = 0;

    for (column = 0; column < N; column++) {
        unsigned selected = 0;
        while (__builtin_popcount(selected) < 2)
            selected |= 1u << random_integer(N);
        for (row = 0; row < N; row++) {
            if ((selected >> row) & 1u) {
                signed char value = 0;
                while (value == 0)
                    value = random_signed_unit();
                matrix[row * N + column] = value;
            }
        }
    }
}

static signed char clamp_i8(int value) {
    if (value < -128)
        return -128;
    if (value > 127)
        return 127;
    return (signed char)value;
}

static int round_shift(int value, int shift) {
    int half;
    if (shift == 0)
        return value;
    half = 1 << (shift - 1);
    return (value + (value >= 0 ? half : half - 1)) >> shift;
}

static void matmul(const signed char *lhs, const signed char *rhs,
                   signed char *result, int right_shift) {
    int row;
    int column;
    int inner;
    for (row = 0; row < N; row++) {
        for (column = 0; column < N; column++) {
            int accumulator = 0;
            for (inner = 0; inner < N; inner++)
                accumulator += lhs[row * N + inner]
                    * rhs[inner * N + column];
            result[row * N + column]
                = clamp_i8(round_shift(accumulator, right_shift));
        }
    }
}

static void transpose(const signed char *source, signed char *destination) {
    int row;
    int column;
    for (row = 0; row < N; row++)
        for (column = 0; column < N; column++)
            destination[column * N + row] = source[row * N + column];
}

static unsigned exponential_lut(int delta) {
    if (delta == 0)
        return 64;
    if (delta == -1)
        return 24;
    if (delta == -2)
        return 9;
    if (delta == -3)
        return 3;
    return 0;
}

static void softmax_rows(const signed char *input,
                         signed char *result) {
    int row;
    int column;
    for (row = 0; row < N; row++) {
        int maximum = -128;
        unsigned total = 0;
        unsigned reciprocal;
        for (column = 0; column < N; column++) {
            int value = input[row * N + column];
            if (value > maximum)
                maximum = value;
        }
        for (column = 0; column < N; column++)
            total += exponential_lut(input[row * N + column] - maximum);
        reciprocal = (64u << 16) / total;
        for (column = 0; column < N; column++) {
            unsigned exponential
                = exponential_lut(input[row * N + column] - maximum);
            unsigned probability = (exponential * reciprocal + 32768u) >> 16;
            result[row * N + column]
                = (signed char)(probability > 127 ? 127 : probability);
        }
    }
}

static unsigned fnv1a(const signed char *values) {
    unsigned hash = 2166136261u;
    int i;
    for (i = 0; i < ELEMENTS; i++) {
        hash ^= (unsigned char)values[i];
        hash *= 16777619u;
    }
    return hash;
}

static void profile_marker(unsigned address) {
    *(volatile unsigned *)address = 1;
}

int main(void) {
    int pass;
    generate_dense(x);
    generate_sparse_projection(wq);
    generate_sparse_projection(wk);
    generate_sparse_projection(wv);

    profile_marker(0x0002fff0u);
    matmul(x, wq, q, 0);
    matmul(x, wk, k, 0);
    matmul(x, wv, v, 0);
    transpose(k, kt);
    matmul(q, kt, scores, 2);
    softmax_rows(scores, probabilities);
    matmul(probabilities, v, output, 6);
    profile_marker(0x0002fff4u);

    pass = fnv1a(q) == 0xc6e1e5f0u
        && fnv1a(k) == 0xa1c4d0beu
        && fnv1a(v) == 0x921796b2u
        && fnv1a(scores) == 0xa08df1e3u
        && fnv1a(probabilities) == 0xc6986f8du
        && fnv1a(output) == 0xe7b21362u;

    printf("ATTENTION size=%d x=%x wq=%x wk=%x wv=%x q=%x k=%x v=%x scores=%x probabilities=%x output=%x status=%s\n",
           N, fnv1a(x), fnv1a(wq), fnv1a(wk), fnv1a(wv),
           fnv1a(q), fnv1a(k), fnv1a(v), fnv1a(scores),
           fnv1a(probabilities), fnv1a(output), pass ? "PASS" : "FAIL");
    return pass ? 0 : 1;
}
