#include <stdint.h>

/*
    Dereferences a fixed non-null address that belongs to no memory object.
    The alias analysis reports an empty pointer set for the access.
    Run with --program.processing.memoryBoundsChecks=true.

    Expected verdict for valid-memsafety.prp: false (dereference of an invalid pointer)
*/

int main() {
    int *p = (int *)(uintptr_t)0x1000;
    *p = 1;
    return 0;
}
