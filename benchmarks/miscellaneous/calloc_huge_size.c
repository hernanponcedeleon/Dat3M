#include <dat3m.h>

extern void *calloc(unsigned long num, unsigned long size);

/*
    A calloc of 2^40 bytes is too large to be zero-initialized byte by byte with init events.
    Instead, reads from it without a write partner (uninit reads) return zero,
    even if uninitialized memory is nondeterministic (modeling.initializeMemory=false).
    EXPECTED: PASS
    EXPECTED (-DFAIL): FAIL
*/

int main(void) {
    int i = __VERIFIER_nondet_int();
    __VERIFIER_assume(0 <= i && i < 4);

    char *p = calloc(1UL << 40, 1);
    if (p == 0) {
        return 0;
    }
#ifdef FAIL
    __VERIFIER_assert(p[i] != 0);
#else
    __VERIFIER_assert(p[i] == 0);
#endif
    return 0;
}
