#include <stdint.h>
#include <assert.h>

/*
    This test shows that we can read from uninitialized memory.
    EXPECTED: FAIL
*/

#define SIZE 10
volatile int *array;

int main()
{
    array = (int*)malloc(SIZE * sizeof(int));
    assert (array[0] == 42);
    return 0;
}
