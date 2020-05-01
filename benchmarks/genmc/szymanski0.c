#include <stdlib.h>
#include <pthread.h>
#include <assert.h>
#include <stdatomic.h>

/* Full memory barrier */
#ifdef NIDHUGG
# define smp_mb() asm volatile ("mfence" ::: "memory")
#elif NIDHUGG_POWER
# define smp_mb() asm volatile ("sync" ::: "memory")
#else
# define smp_mb() atomic_thread_fence(memory_order_seq_cst)
#endif

atomic_int x;
atomic_int flag1;
atomic_int flag2;

void __VERIFIER_assume(int);

void *thread_1(void *unused)
{
    atomic_store_explicit(&flag1, 1, memory_order_relaxed);
    smp_mb();
    __VERIFIER_assume(atomic_load_explicit(&flag2, memory_order_relaxed) < 3);

    atomic_store_explicit(&flag1, 3, memory_order_relaxed);
    smp_mb();
    if (atomic_load_explicit(&flag2, memory_order_relaxed) == 1) {
        atomic_store_explicit(&flag1, 2, memory_order_relaxed);
        smp_mb();
        __VERIFIER_assume(atomic_load_explicit(&flag2, memory_order_relaxed) == 4);
    }

    atomic_store_explicit(&flag1, 4, memory_order_relaxed);
    smp_mb();
    __VERIFIER_assume(atomic_load_explicit(&flag2, memory_order_relaxed) < 2);

    /* Critical section start */
    atomic_store_explicit(&x, 0, memory_order_relaxed);
    atomic_load_explicit(&x, memory_order_relaxed);
    assert(atomic_load_explicit(&x, memory_order_relaxed) <= 0);
    smp_mb();
    /* Critical section end */

    __VERIFIER_assume(2 > atomic_load_explicit(&flag2, memory_order_relaxed) ||
              atomic_load_explicit(&flag2, memory_order_relaxed) > 3);
    atomic_store_explicit(&flag1, 0, memory_order_relaxed);
    return NULL;
}

void *thread_2(void *unused)
{
    atomic_store_explicit(&flag2, 1, memory_order_relaxed);
    smp_mb();
    __VERIFIER_assume(atomic_load_explicit(&flag1, memory_order_relaxed) < 3);

    atomic_store_explicit(&flag2, 3, memory_order_relaxed);
    smp_mb();
    if (atomic_load_explicit(&flag1, memory_order_relaxed) == 1) {
        atomic_store_explicit(&flag2, 2, memory_order_relaxed);
        smp_mb();
        __VERIFIER_assume(atomic_load_explicit(&flag1, memory_order_relaxed) == 4);
    }

    atomic_store_explicit(&flag2, 4, memory_order_relaxed);
    smp_mb();
    __VERIFIER_assume(atomic_load_explicit(&flag1, memory_order_relaxed) < 2);

    /* Critical section start */
    atomic_store_explicit(&x, 1, memory_order_relaxed);
    atomic_load_explicit(&x, memory_order_relaxed);
    assert(atomic_load_explicit(&x, memory_order_relaxed) >= 1);
    smp_mb();
    /* Critical section end */

    __VERIFIER_assume(2 > atomic_load_explicit(&flag1, memory_order_relaxed) ||
              atomic_load_explicit(&flag1, memory_order_relaxed) > 3);
    atomic_store_explicit(&flag2, 0, memory_order_relaxed);
    return NULL;
}

int main()
{
	pthread_t t1, t2;

	if (pthread_create(&t1, NULL, thread_1, NULL))
		abort();
	if (pthread_create(&t2, NULL, thread_2, NULL))
		abort();

	if (pthread_join(t1, NULL))
		abort();
	if (pthread_join(t2, NULL))
		abort();

#ifdef NIDHUGG_PRINT_COMPLETE_EXECS
	printf("Full execution encountered\n");
#endif
	return 0;
}
