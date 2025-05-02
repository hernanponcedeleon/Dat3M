#include <stdatomic.h>
#include <pthread.h>
#include <dat3m.h>

// ISSUE: Interrupt handlers in worker threads may happen after the worker thread terminates.
// Expected: FAIL.

atomic_int x;

void *handler(void *arg)
{
    atomic_store_explicit(&x, 1, memory_order_relaxed);
    return NULL;
}

void *thread1(void *arg)
{
    __VERIFIER_register_interrupt_handler(handler);
    //__VERIFIER_disable_irq(); // should disable this behavior.
    return NULL;
}

int main()
{
    pthread_t t1;
    pthread_create(&t1, NULL, thread1, NULL);
    pthread_join(t1, NULL);
    int x0 = atomic_load_explicit(&x, memory_order_relaxed);
    __VERIFIER_assert(x0 == 1);
    return 0;
}
