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
    Test case: Three loops that interfere with each other..
    Expected result: FAIL under all memory models.
    NOTE: Any pair of loops would terminate, only all three together fail.
*/

atomic_int x = 0;
atomic_int y = 0;
atomic_int z = 0;

void *thread(void *unused)
{
    await_while(y != 1) {
        x = 1;
        x = 0;
        y = 1;
    }
    return 0;
}

void *thread2(void *unused) {
    await_while (x == 1 && y != 0 && z != 3) {
        for (int i = 0; i < 4; i++) {
            z = i;
        }
    }
    return 0;
}

void *thread3(void *unused) {
    await_while (z == 1) {
        y = 0;
        z = 0;
    }
    return 0;
}

int main()
{
    pthread_t t1, t2, t3;
    pthread_create(&t1, NULL, thread, NULL);
    pthread_create(&t2, NULL, thread2, NULL);
    pthread_create(&t3, NULL, thread3, NULL);

    return 0;
}