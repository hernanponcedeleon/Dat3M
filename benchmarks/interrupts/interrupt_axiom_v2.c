#include <stdlib.h>
#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>

atomic_int x, y, z;

pthread_t h;
void *handler(void *arg)
{
    if(atomic_load_explicit(&x, memory_order_relaxed) == 1 && atomic_load_explicit(&y, memory_order_relaxed) == 0) {
        atomic_store_explicit(&z, 1, memory_order_relaxed);
        atomic_thread_fence(memory_order_seq_cst);
    }
    return NULL;
}

void *thread_1(void *arg)
{   
    __VERIFIER_make_interrupt_handler();
    pthread_create(&h, NULL, handler, NULL);

    atomic_store_explicit(&x, 1, memory_order_relaxed);
    atomic_store_explicit(&y, 1, memory_order_relaxed);

    pthread_join(h, NULL);

    return NULL;
}

void *thread_2(void *arg)
{
    if(atomic_load_explicit(&z, memory_order_relaxed) == 1 && atomic_load_explicit(&y, memory_order_relaxed) == 1) {
        atomic_thread_fence(memory_order_seq_cst);
        __VERIFIER_assert(atomic_load_explicit(&x, memory_order_relaxed) == 1);
    }
    return NULL;
}

int main()
{   
    pthread_t t1, t2;
    pthread_create(&t1, NULL, thread_1, NULL);
    pthread_create(&t2, NULL, thread_2, NULL);

    return 0;
}
