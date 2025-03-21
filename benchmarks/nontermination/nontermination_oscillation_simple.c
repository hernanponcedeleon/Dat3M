#include <pthread.h>
#include <stdatomic.h>
#include "dat3m.h"

/*
    Test case: Non-termination with oscillating memory value
    Expected result: FAIL under all memory models.
*/

atomic_int x = 0;

int main()
{
    __VERIFIER_loop_bound(3);
    while (x != 2) {
        x = !x;
    }
    return 0;
}