#include <pthread.h>
#include <stdatomic.h>
#include <assert.h>

atomic_bool flag;
atomic_int data;

void *producer(void *arg)
{
    atomic_store_explicit(&data, 42, memory_order_relaxed);
#ifdef FAIL
    atomic_store_explicit(&flag, 1, memory_order_relaxed);
#else
    atomic_store_explicit(&flag, 1, memory_order_release);
#endif
    return NULL;
}

void *consumer(void *arg)
{
    while (atomic_load_explicit(&flag, memory_order_acquire) != 1) ;
    assert(atomic_load_explicit(&data, memory_order_relaxed) == 42);
    return NULL;
}

int main()
{
    atomic_init(&flag, 0);
    pthread_t producer_t, consumer_t;
    pthread_create(&producer_t, NULL, producer, NULL);
    pthread_create(&consumer_t, NULL, consumer, NULL);
}
