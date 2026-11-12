#include <assert.h>
#include <stddef.h>

/*
    With safe allocations (default), heap allocations never return NULL: executions where an allocation
    does not fit into the 32-bit address space are discarded. Allocations that fit must not overlap.
    Without safe allocations, malloc may return NULL here and the first assertion fails.
*/

extern unsigned int __VERIFIER_nondet_uint(void);
extern void *malloc(size_t size);

int g = 7;

int main(void) {
    size_t size = __VERIFIER_nondet_uint();
    char *big = malloc(size);
    int *small = malloc(sizeof(int));
    assert(big != NULL && small != NULL);

    *small = 42;
    if (size > 0) {
        big[0] = 0;
        big[size - 1] = 0;
    }
    assert(*small == 42);
    assert(g == 7);
    return 0;
}
