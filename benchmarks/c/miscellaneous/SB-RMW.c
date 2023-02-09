#include <stdlib.h>
#include <pthread.h>
#include <assert.h>
#include <stdatomic.h>

atomic_int x, y;
int a, b;

void *thread_1(void *unused)
{
    atomic_fetch_add_explicit(&x, 1, memory_order_seq_cst);
    a = atomic_load_explicit(&y, memory_order_seq_cst);
	return NULL;
}

void *thread_2(void *unused)
{
    atomic_fetch_add_explicit(&y, 1, memory_order_seq_cst);
    b = atomic_load_explicit(&x, memory_order_seq_cst);
	return NULL;
}

int main()
{
	pthread_t t1, t2;

	pthread_create(&t1, NULL, thread_1, NULL);
	pthread_create(&t2, NULL, thread_2, NULL);

	pthread_join(t1, NULL);
	pthread_join(t2, NULL);

	assert(!(a == 0 && b == 0));

	return 0;
}
