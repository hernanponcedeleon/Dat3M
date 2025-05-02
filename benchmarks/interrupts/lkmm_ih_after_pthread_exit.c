#include <lkmm.h>
#include <pthread.h>
#include <dat3m.h>

// ISSUE: Interrupt handlers in worker threads may happen after the worker thread terminates.
// Expected: FAIL.

int x;

void *handler(void *arg)
{
    WRITE_ONCE(x, 1);
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
    int x0 = READ_ONCE(x);
    __VERIFIER_assert(x0 == 1);
    return 0;
}
