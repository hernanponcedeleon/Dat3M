#include <stdint.h>
#include <assert.h>
#include <dat3m.h>


#define MAX_SIZE 10

int main()
{
    int size = __VERIFIER_nondet_int();
    __VERIFIER_assume(size > 0 && size <= MAX_SIZE);
    int *array = malloc(size * sizeof(int));

    __VERIFIER_loop_bound(MAX_SIZE + 1);
    for (int i = 0; i < size; i++) {
        array[i] = i;
    }

    int sum = 0;
    __VERIFIER_loop_bound(MAX_SIZE + 1);
    for (int i = 0; i < size; i++) {
        sum += array[i];
    }

    // Fails if size == MAX_SIZE because then equality holds
    assert(sum < (MAX_SIZE * (MAX_SIZE - 1)) / 2);
}
