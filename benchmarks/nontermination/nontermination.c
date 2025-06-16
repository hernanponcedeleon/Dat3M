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
    Test case: Oscillating memory value but the same value is constantly observed
    Expected result: FAIL under all memory models.
*/

atomic_int x = 0;
atomic_int y = 0;

void *thread(void *unused)
{
    await_while(y != 1) {
        x = 1;
        x = 2;
    }
    return 0;
}

void *thread2(void *unused) {
    await_while (x != 2) { }
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