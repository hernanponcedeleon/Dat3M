#include <dat3m.h>

extern void *malloc(unsigned long size);
extern void *calloc(unsigned long num, unsigned long size);

/*
    The memory of a calloc with a nondeterministic size cannot be zero-initialized with init events.
    Instead, reads from it without a write partner (uninit reads) return zero,
    even if uninitialized memory is nondeterministic (modeling.initializeMemory=false).
    EXPECTED: PASS
    With -DFAIL, we read from malloc'ed memory instead, which is not zeroed.
    EXPECTED (-DFAIL, modeling.initializeMemory=false): FAIL
*/

int main()
{
    int n = __VERIFIER_nondet_int();
    __VERIFIER_assume(n > 0 && n <= 4);
    int i = __VERIFIER_nondet_int();
    __VERIFIER_assume(i >= 0 && i < n);

    int *a = calloc(n, sizeof(int));
    int *b = malloc(n * sizeof(int));
    if (a == 0 || b == 0) {
        return 0;
    }

    __VERIFIER_assert(a[i] == 0);
    a[i] = 1;
    __VERIFIER_assert(a[i] == 1);
#ifdef FAIL
    __VERIFIER_assert(b[i] == 0);
#endif
    return 0;
}
