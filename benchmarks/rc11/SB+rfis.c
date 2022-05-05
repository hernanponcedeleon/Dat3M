#include <stdlib.h>
#include <pthread.h>
#include <assert.h>
#include <stdatomic.h>

atomic_int x, y;

int a, b, c, d;

void *thread_1(void *unused)
{
	atomic_store_explicit(&x, 1, memory_order_release);
	int r0 = atomic_load_explicit(&x, memory_order_seq_cst);
	int r1 = atomic_load_explicit(&y, memory_order_seq_cst);
	atomic_thread_fence(memory_order_seq_cst);
	a = r0;
	b = r1;
	return NULL;
}

void *thread_2(void *unused)
{
	atomic_store_explicit(&y, 1, memory_order_release);
	int r0 = atomic_load_explicit(&y, memory_order_seq_cst);
	int r1 = atomic_load_explicit(&x, memory_order_seq_cst);
	atomic_thread_fence(memory_order_seq_cst);
	c = r0;
	d = r1;
	return NULL;
}

int main()
{
	pthread_t t1, t2;

	pthread_create(&t1, NULL, thread_1, NULL);
	pthread_create(&t2, NULL, thread_2, NULL);

	pthread_join(t1, NULL);
	pthread_join(t2, NULL);

	assert(!(a == 1 && b == 0 && c == 1 && d == 0));

	return 0;
}
