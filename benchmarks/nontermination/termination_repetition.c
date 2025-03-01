#include <pthread.h>
#include <stdatomic.h>
#include "dat3m.h"

/*
    Test case: Every odd loop iteration is identical (repeating), but loop terminates nevertheless due to even iterations
    Expected result: UNKNOWN/PASS under all standard memory models.

    NOTE: We test that Dartagnan does not accidentally think the repeating odd iterations witness non-termination.
*/

#define N 2

atomic_int x = 0;
atomic_int flag = 0;

int main()
{
    __VERIFIER_loop_bound(2*N - 1); // Passes with 2*N, deliberately not unrolled fully!
    while(1) {
        if (!flag) {
            flag = 1;
        } else {
            if ((++x) == N) { break; }
            flag = 0;
        }
    }
    return 0;
}