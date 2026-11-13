extern unsigned long __VERIFIER_nondet_ulong(void);
extern void abort(void);

/*
    The address of the access is pinned via a nondeterministic index.
    For -DFAIL, the access ends exactly at the end of the address space, so a bounds check of the form
    "addr + accessSize <= base + size" would wrap around and miss the violation.
    Run with --program.processing.memoryBoundsChecks=true.

    Expected verdicts for valid-memsafety.prp:
      default:     true  (the write is to the last element of the array)
      -DFAIL:      false (the write is far out of bounds, at the end of the address space)
*/

int a[4];

int main() {
    int *p = a;
    unsigned long i = __VERIFIER_nondet_ulong();
#ifdef FAIL
    if ((unsigned long)(p + i) != 0xFFFFFFFFFFFFFFFCul) abort();
#else
    if ((unsigned long)(p + i) != (unsigned long)(p + 3)) abort();
#endif
    p[i] = 1;
    return 0;
}
