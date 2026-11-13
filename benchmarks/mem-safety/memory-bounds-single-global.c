/*
    The only memory object of the program is a global array, accessed through a pointer
    (so UBSan's array-bounds check does not apply). The alias analysis reports "all objects" for the access.
    Run with --program.processing.memoryBoundsChecks=true.

    Expected verdicts for valid-memsafety.prp:
      default:     true
      -DFAIL:      false (the index may be one past the end of the array)
*/

extern int __VERIFIER_nondet_int(void);

#ifdef FAIL
#define LIMIT 4
#else
#define LIMIT 3
#endif

int a[4];

int main() {
    int i = __VERIFIER_nondet_int();
    if (i < 0 || i > LIMIT) return 0;
    int *p = a;
    p[i] = 1;
    return 0;
}
