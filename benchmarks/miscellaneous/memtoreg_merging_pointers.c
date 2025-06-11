#include <assert.h>
#include <dat3m.h>

// Issue: If MemToReg does not handle dataflow correctly, it may remove the allocation of an array, while keeping its usages.
// Expected: PASS

int main()
{
    int a[2];
    int *i, *j;
    if (__VERIFIER_nondet_int())
        i = &a[0], j = &a[0];
    else
        i = &a[1], j = &a[1];
    *i = 1;
    assert(*j == 1);
    return 0;
}