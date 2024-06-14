#include <stdlib.h>
#include <pthread.h>
#include <assert.h>
#include <stdatomic.h>

atomic_int x, y, z1, z2;

void *thread_1(void *unused)
{
	atomic_store_explicit(&x, 1, memory_order_relaxed);
    atomic_exchange_explicit(&z1, 0, memory_order_seq_cst);
    atomic_load_explicit(&z2, memory_order_seq_cst);
	atomic_store_explicit(&y, 1, memory_order_relaxed);
	return NULL;
}

void *thread_2(void *unused)
{
	if(atomic_load_explicit(&y, memory_order_acquire)) {
        assert(atomic_load_explicit(&x, memory_order_relaxed));
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
