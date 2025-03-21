#include <stdint.h>
#include <assert.h>
#include <dat3m.h>
#include <stdlib.h>

int main()
{
    int size_int = __VERIFIER_nondet_int();
    __VERIFIER_assume(size_int > 0);
    // NOTE: Putting the assumption on the below <size> rather than <size_int> gives FAIL.
    // This is because the non-det int value is sign-extended to size_t and so negative values are extended
    // to very large sizes that can overflow, allowing the addresses of different allocations to overlap!
    size_t size = (size_t)size_int;
    int *array = malloc(size * sizeof(int));
    int *array_2 = malloc(size * sizeof(int));

    assert (array != array_2);
    assert (((size_t)array) % 8 == 0);
    assert (((size_t)array_2) % 8 == 0);
}
