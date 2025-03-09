#include <pthread.h>
#include <stdatomic.h>
#include "dat3m.h"

/*
    Test case: Asymmetric non-termination where loop 1 runs twice as often as loop 2
    Expected result: FAIL under all memory models.

    NOTE: Requires L1 and L2 to run at least 4 resp. 2 times.
*/

atomic_int x = 0;
atomic_int y = 0;

void *thread(void *unused)
{
    __VERIFIER_loop_bound(5);
    while(y != 1) {
        x = 1 - x;
    }
    return 0;
}

void *thread2(void *unused) {
    __VERIFIER_loop_bound(3);
    while (1) {
        if (x == 0) {
            break;
        }
        if (x == 1) {
            break;
        }
        y = 0; // Just to add side-effect and force unrolling
    }
    y = 1;
    return 0;
}

int main()
{
    pthread_t t1, t2;
    pthread_create(&t1, NULL, thread, NULL);
    pthread_create(&t2, NULL, thread2, NULL);

    return 0;
}