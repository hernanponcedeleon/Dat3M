#include <stdlib.h>

/*
    Dereferences a pointer read from heap memory that was never written.
    No memory object flows into the pointer, so the alias analysis reports an empty pointer set.
    Run with --program.processing.memoryBoundsChecks=true.

    Expected verdict for valid-memsafety.prp: false (dereference of an invalid pointer)
*/

int main() {
    int **pp = malloc(sizeof(int *));
    if (pp == 0) return 0;
    int *p = *pp;
    if (p == 0) return 0;
    *p = 1;
    return 0;
}
