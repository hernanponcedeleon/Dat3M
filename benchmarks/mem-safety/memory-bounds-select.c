#include <stdlib.h>

/*
    The pointer refers to either of the program's two heap buffers (chosen by a select),
    so the alias analysis reports "all objects" for the access.
    Run with --program.processing.memoryBoundsChecks=true.

    Expected verdicts for valid-memsafety.prp:
      default:     true
      -DFAIL:      false (the write is out of bounds if the smaller buffer is chosen)
*/

extern int __VERIFIER_nondet_int(void);

#ifdef FAIL
#define SIZE_A 4
#else
#define SIZE_A 8
#endif

int main() {
    int *a = malloc(SIZE_A * sizeof(int));
    int *b = malloc(8 * sizeof(int));
    if (a == 0 || b == 0) return 0;
    int *p = __VERIFIER_nondet_int() ? a : b;
    p[4] = 1;
    return 0;
}
