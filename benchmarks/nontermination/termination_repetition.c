#include <pthread.h>
#include <stdatomic.h>
#ifdef USE_GENMC
#include <genmc.h>
#ifdef ANNOTATE_LOOPS
#define await_while(cond)                                                  \
        for (__VERIFIER_loop_begin();                                      \
             (__VERIFIER_spin_start(),                                     \
              (cond) ? 1 : (__VERIFIER_spin_end(1), 0));                   \
             __VERIFIER_spin_end(0))
#else
#define await_while while
#endif
#define __VERIFIER_loop_bound(x)
#else
#include <dat3m.h>
#define await_while while
#endif


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
    await_while(1) {
        if (!flag) {
            flag = 1;
        } else {
            if ((++x) == N) { break; }
            flag = 0;
        }
    }
    return 0;
}