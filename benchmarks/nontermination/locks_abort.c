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

pthread_mutex_t m;

void *thread(void *unused)
{
    pthread_mutex_lock(&m);
    if(__VERIFIER_nondet_bool()) {
        abort();
    }
    pthread_mutex_unlock(&m);
    return 0;
}

int main()
{
    pthread_t t1, t2;
    pthread_mutex_init(&m, 0);
    pthread_create(&t1, NULL, thread, NULL);
    pthread_create(&t2, NULL, thread, NULL);

    return 0;
}