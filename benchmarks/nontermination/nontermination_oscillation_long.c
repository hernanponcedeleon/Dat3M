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
    Test case: Non-termination with oscillating memory value over N iterations
    Expected result: FAIL under all memory models.
*/

#define N 10

atomic_int x = 0;
int main()
{
    __VERIFIER_loop_bound(N + 1);
    await_while (x < N) {
        x = (x + 1) % N;
    }
    return 0;
}