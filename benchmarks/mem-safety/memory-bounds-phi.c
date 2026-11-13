#include <stdlib.h>

/*
    The pointer refers to either of the program's two heap buffers (merged via a phi),
    so the alias analysis reports "all objects" for the access.
    Run with --program.processing.memoryBoundsChecks=true.

    Expected verdicts for valid-memsafety.prp:
      default:     true
      -DFAIL:      false (the write is one element past the end of either buffer)
*/

extern int __VERIFIER_nondet_int(void);

#ifdef FAIL
#define INDEX 4
#else
#define INDEX 3
#endif

int main() {
    int *a = malloc(4 * sizeof(int));
    int *b = malloc(4 * sizeof(int));
    if (a == 0 || b == 0) return 0;
    int *p;
    if (__VERIFIER_nondet_int()) {
        p = a;
    } else {
        p = b;
    }
    p[INDEX] = 1;
    return 0;
}
