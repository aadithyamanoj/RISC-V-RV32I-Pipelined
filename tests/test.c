#include "libmc.h"

char dummy_string[128] = "This is just here to reassure you elftohex is working";

static int failures = 0;

static void expect_int(const char* label, int got, int exp) {
    if (got != exp) {
        printf("FAIL %s got=%d exp=%d\n", label, got, exp);
        failures++;
    } else {
        printf("PASS %s = %d\n", label, exp);
    }
}

static void expect_str(const char* label, const char* got, const char* exp) {
    if (strcmp(got, exp) != 0) {
        printf("FAIL %s got=\"%s\" exp=\"%s\"\n", label, got, exp);
        failures++;
    } else {
        printf("PASS %s = \"%s\"\n", label, exp);
    }
}

static void test_strlen(void) {
    expect_int("strlen empty", strlen(""), 0);
    expect_int("strlen hello", strlen("hello"), 5);
}

static void test_strcmp(void) {
    expect_int("strcmp same", strcmp("abc", "abc"), 0);
    expect_int("strcmp lt", strcmp("abc", "abd") < 0, 1);
    expect_int("strcmp gt", strcmp("abd", "abc") > 0, 1);
}

static void test_memset(void) {
    char buf[8];
    memset(buf, 0, sizeof(buf));
    buf[7] = '\0';
    memset(buf, 'x', 3);
    expect_str("memset prefix", buf, "xxx");
}

static void test_strchr(void) {
    const char* msg = "libmc rocks";
    const char* found = strchr(msg, 'r');
    if (found == 0) {
        expect_int("strchr found", 0, 1);
        return;
    }
    expect_int("strchr offset", (int)(found - msg), 6);
}

static void test_strtok(void) {
    char scratch[32];
    char* token;

    memset(scratch, 0, sizeof(scratch));
    scratch[0] = 'a';
    scratch[1] = ',';
    scratch[2] = 'b';
    scratch[3] = ',';
    scratch[4] = 'c';
    scratch[5] = '\0';
    token = strtok(scratch, ",");
    expect_str("strtok tok0", token, "a");
    token = strtok(0, ",");
    expect_str("strtok tok1", token, "b");
    token = strtok(0, ",");
    expect_str("strtok tok2", token, "c");
    token = strtok(0, ",");
    expect_int("strtok end", token == 0, 1);
}

static void test_sprintf(void) {
    char buf[64];
    char fmt_val[] = "val=%d hex=%s";
    char hex_literal[] = "2a";
    int len = sprintf(buf, fmt_val, 42, hex_literal);
    expect_int("sprintf len", len, 9);
    expect_str("sprintf text", buf, "val=42 hex=2a");
}

int main(void) {
    printf("Running libmc smoke tests\n");
    test_strlen();
    test_strcmp();
    test_memset();
    test_strchr();
    test_strtok();
    test_sprintf();
    if (failures == 0) {
        printf("All libmc smoke tests passed\n");
    } else {
        printf("%d libmc smoke tests failed\n", failures);
    }
    return failures;
}
