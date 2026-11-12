#include <assert.h>
#include <stddef.h>
#include <stdint.h>

/*
    On 32-bit, a heap allocation with a nondeterministic size can be almost as large as the whole address space.
    Such an allocation must not cause later objects to wrap around the address space
    (e.g., to address 0 or on top of other objects).

    Expected verdicts:
      --modeling.safeAllocs=false:  default: true
                                    -DFAIL:  false (malloc returns NULL if the object does not fit)
      --modeling.safeAllocs=true:   default: true
                                    -DFAIL:  true (executions where an allocation does not fit are discarded)
*/

extern unsigned int __VERIFIER_nondet_uint(void);
extern void *malloc(size_t size);

int g = 7;

int main(void) {
    size_t size = __VERIFIER_nondet_uint();
    char *big = malloc(size);
    int *small = malloc(sizeof(int));
#ifdef FAIL
    assert(big != NULL && small != NULL);
#endif
    if (big == NULL || small == NULL) {
        return 0;
    }

    *small = 42;
    if (size > 0) {
        big[0] = 0;
        big[size - 1] = 0;
        // The allocated object does not wrap around.
        assert((uintptr_t)big < (uintptr_t)big + size);
    }

    assert((void *)small != (void *)big);
    assert(*small == 42);
    assert(g == 7);
    return 0;
}
