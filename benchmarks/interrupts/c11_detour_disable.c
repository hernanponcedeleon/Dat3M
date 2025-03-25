#include <stdlib.h>
#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>
#include <dat3m.h>

atomic_int x, y;
int a, b;

pthread_t h;
void *handler(void *arg)
{
    atomic_store_explicit(&y, 3, memory_order_seq_cst);
    return NULL;
}

void *thread_1(void *arg)
{
    __VERIFIER_make_interrupt_handler();
    pthread_create(&h, NULL, handler, NULL);

    __VERIFIER_disable_irq();
    atomic_store_explicit(&x, 1, memory_order_relaxed);
    a = atomic_load_explicit(&y, memory_order_relaxed);
    __VERIFIER_enable_irq();

    pthread_join(h, 0);

    return NULL;
}

void *thread_2(void *arg)
{
    b = atomic_load_explicit(&x, memory_order_relaxed);
    atomic_store_explicit(&y, 2, memory_order_release);
    return NULL;
}

int main()
{
    pthread_t t1, t2;

    pthread_create(&t1, 0, thread_1, NULL);
    pthread_create(&t2, 0, thread_2, NULL);
    pthread_join(t1, 0);
    pthread_join(t2, 0);

    __VERIFIER_assert(!(b == 1 && a == 3 && y == 3));

    return 0;
}
