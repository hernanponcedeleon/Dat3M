#include <stdlib.h>
#include <stdbool.h>
#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>
#include <dat3m.h>

atomic_int x, y, a1, a2, b1, b2;
int r1, r2, t1, u1, t2, u2;

pthread_t h;
void *handler(void *arg)
{
    r1 = atomic_load_explicit(&x, memory_order_relaxed);
    atomic_thread_fence(memory_order_seq_cst);
    r2 = atomic_load_explicit(&y, memory_order_relaxed);
    return NULL;
}

void *thread_1(void *arg)
{
    __VERIFIER_register_interrupt_handler(handler);

    atomic_store_explicit(&b1, 1, memory_order_relaxed);
    atomic_store_explicit(&x, 1, memory_order_relaxed);
    atomic_store_explicit(&a1, 1, memory_order_relaxed);
    atomic_store_explicit(&b2, 1, memory_order_relaxed);
    atomic_store_explicit(&y, 1, memory_order_relaxed);
    atomic_store_explicit(&a2, 1, memory_order_relaxed);

    return NULL;
}

void *thread_2(void *arg)
{
    t1 = atomic_load_explicit(&a1, memory_order_relaxed);
    u1 = atomic_load_explicit(&b1, memory_order_relaxed);
    atomic_thread_fence(memory_order_seq_cst);
    t2 = atomic_load_explicit(&a2, memory_order_relaxed);
    u2 = atomic_load_explicit(&b2, memory_order_relaxed);
    return NULL;
}

int main()
{
    pthread_t thread1, thread2;

    pthread_create(&thread1, 0, thread_1, NULL);
    pthread_create(&thread2, 0, thread_2, NULL);
    pthread_join(thread1, 0);
    pthread_join(thread2, 0);

    bool reorder_bx = (t1 == 1 && t2 == 0); 
    bool reorder_ya = (u1 == 1 && u2 == 0);
    if (r1 == 1 && r2 == 0) { 
        __VERIFIER_assert(! reorder_bx || ! reorder_ya);
    }

    return 0;
}
