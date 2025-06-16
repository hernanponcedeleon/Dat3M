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

atomic_int x;

void* thread0(void *unused)
{
    // Anything can go here, we just need the thread to exist
    return NULL;
}

void* thread1(void *unused)
{
    await_while(atomic_load_explicit(&x, memory_order_seq_cst) == 0);
    return NULL;
}

int main()
{
    pthread_t t0, t1;
    atomic_init(&x, 0);

    pthread_create(&t0, NULL, thread0, NULL);
    pthread_create(&t1, NULL, thread1, NULL);

    pthread_join(t0, NULL);

    atomic_store_explicit(&x, 1, memory_order_seq_cst);

    pthread_join(t1, NULL);

    return 0;
}
