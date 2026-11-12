#include <stdlib.h>

/*
    The only memory object of the program is a heap buffer, so the alias analysis reports "all objects"
    for the access.
    Run with --program.processing.memoryBoundsChecks=true.

    Expected verdicts for valid-memsafety.prp:
      default:     true
      -DFAIL:      false (the write is one element past the end of the buffer)
*/

#ifdef FAIL
#define INDEX 4
#else
#define INDEX 3
#endif

int main() {
    int *p = malloc(4 * sizeof(int));
    if (p == 0) return 0;
    p[INDEX] = 1;
    return 0;
}
