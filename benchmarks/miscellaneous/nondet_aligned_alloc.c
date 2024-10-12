#include <stdint.h>
#include <assert.h>
#include <dat3m.h>
#include <stdlib.h>

#define SIZE_1 42

int main()
{
    int size_int = __VERIFIER_nondet_int();
    int align_int = __VERIFIER_nondet_int();
    __VERIFIER_assume(size_int > 0);
    __VERIFIER_assume(align_int > 0);
    size_t size = (size_t)size_int;
    size_t align = (size_t)align_int;
    int *array = malloc(SIZE_1 * sizeof(int));
    int *array_2 = aligned_alloc(align, size * sizeof(int));
    // NOTE: making the first allocation non-det-sized makes the solver extremely slow to verify the
    // custom aligned allocation. Even when fixing the alignment to a constant it gets super slow if that constant
    // is not a power of two. In other words, aligning variable-sized addresses is very expensive currently, especially
    // for non-power-of-two alignments (those don't exist in practice though).

    assert ((size_t)array_2 - (size_t)array >= SIZE_1 * sizeof(int));
    assert (((size_t)array) % 8 == 0); // Default alignment
    assert (((size_t)array_2) % align == 0); // Custom alignment
}
