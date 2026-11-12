#include <stdlib.h>

/*
    Heap buffer with a nondeterministic size. The size of the memory object is not a constant.
    Run with --program.processing.memoryBoundsChecks=true.

    Expected verdicts for valid-memsafety.prp:
      default:     true
      -DFAIL:      false (the write is one element past the end of the buffer)
*/

extern int __VERIFIER_nondet_int(void);

#ifdef FAIL
#define OFFSET 0
#else
#define OFFSET 1
#endif

int main() {
    int n = __VERIFIER_nondet_int();
    if (n <= 0 || n > 8) return 0;
    int *p = malloc(n * sizeof(int));
    if (p == 0) return 0;
    p[n - OFFSET] = 1;
    return 0;
}
