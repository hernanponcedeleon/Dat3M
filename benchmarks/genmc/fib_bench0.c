#include <assert.h>
#include <pthread.h>
#include <stdatomic.h>

atomic_int x = ATOMIC_VAR_INIT(1);
atomic_int y = ATOMIC_VAR_INIT(1);

#ifndef NUM
#define NUM 5
#endif

void *thread_1(void* arg)
{
    for (int i = 0; i < NUM; i++) {
        int prev_x = atomic_load_explicit(&x, memory_order_acquire);
        int prev_y = atomic_load_explicit(&y, memory_order_acquire);
        atomic_store_explicit(&x, prev_x + prev_y, memory_order_release);
    }
    return NULL;
}

void *thread_2(void* arg)
{
    for (int i = 0; i < NUM; i++) {
        int prev_x = atomic_load_explicit(&x, memory_order_acquire);
        int prev_y = atomic_load_explicit(&y, memory_order_acquire);
        atomic_store_explicit(&y, prev_x + prev_y, memory_order_release);
    }
    return NULL;
}

void *thread_3(void *arg)
{
    if (atomic_load_explicit(&x, memory_order_acquire) > 144 ||
        atomic_load_explicit(&y, memory_order_acquire) > 144)
        assert(0);
    return NULL;
}

int main()
{
	pthread_t t1, t2, t3;

	pthread_create(&t1, NULL, thread_1, NULL);
	pthread_create(&t2, NULL, thread_2, NULL);
	pthread_create(&t3, NULL, thread_3, NULL);

	return 0;
}
