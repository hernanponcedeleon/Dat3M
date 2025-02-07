#include <pthread.h>
#include <stdatomic.h>

/*
    Test case: Non-termination with oscillating memory value over N iterations
    Expected result: FAIL under all memory models.
*/

#define N 10

atomic_int x = 0;
int main()
{
    __VERIFIER_loop_bound(N + 1);
    while (x < N) {
        x = (x + 1) % N;
    }
    return 0;
}