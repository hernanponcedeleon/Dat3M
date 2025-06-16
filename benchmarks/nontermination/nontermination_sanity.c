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
    Test case: Special case to ensure that Dartagnan's internal optimization pipeline does not hide side-effects:
               Naively, unrolling the loop k < 10 times and performing SCCP results in k empty iteration bodies,
               which looks identical to a k-times unrolled while(1)-loop.
               However, the insufficiently unrolled loop will terminate, the while(1)-loop will not and
               so need to be distinguished somehow (e.g. by instrumentation).
*/

int main()
{
    int i = 0;
    await_while(!(i > 10)) {
        i++;
    }

    return 0;
}