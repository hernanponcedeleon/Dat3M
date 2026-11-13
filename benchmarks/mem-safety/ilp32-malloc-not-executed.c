#include <assert.h>
#include <stddef.h>

/*
    On 32-bit, each of the two allocations fits into the address space, but not both of them.
    Since only one of them is executed, it must be able to succeed: allocations that are not executed
    must not reserve memory.

    Expected verdicts:
      default: true
      -DFAIL:  false (the executed allocation can succeed)
*/

extern void *malloc(size_t size);
extern int __VERIFIER_nondet_int(void);

char *g;

int main(void) {
    if (__VERIFIER_nondet_int()) {
        g = malloc(0x7FFFFFFFu);
    } else {
        char *p = malloc(0x7FFFFFFFu);
#ifdef FAIL
        assert(p == NULL);
#endif
        if (p != NULL) {
            *p = 1;
        }
    }
    return 0;
}
