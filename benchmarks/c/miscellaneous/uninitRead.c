#include <stdint.h>
#include <assert.h>

/*
    This test shows that we can read from uninitialized memory.
    EXPECTED: FAIL
    PREVIOUSLY: We returned PASS because the array read had no possible rf-edge and thus the program had no valid executions.
*/

#define SIZE 10
volatile int array[SIZE];

int main()
{
    assert (array[SIZE] == 42);
    return 0;
}
