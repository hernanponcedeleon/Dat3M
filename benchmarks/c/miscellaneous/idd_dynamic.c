#include <stdlib.h>
#include <pthread.h>
#include <assert.h>
#include <stdatomic.h>

// This test shows that data-dependencies have to be treated dynamically
// Expected result: FAIL under ARM8 (possibly under other weak models as well)

atomic_int x, y, z;

void *thread_1(void *unused)
{
	int r = atomic_load_explicit(&x, memory_order_relaxed);
	int s = atomic_load_explicit(&y, memory_order_relaxed);
	int u = s;
	if (r == 0) {
		atomic_store_explicit(&z, 4, memory_order_relaxed); // To avoid LLVM generating a branchless instruction
		s = 42;
	}
	atomic_store_explicit(&x, s, memory_order_relaxed); // May get reordered with load(&y)
	assert (u != 42);
	return NULL;
}

void *thread_2(void *unused)
{
	int a = atomic_load_explicit(&x, memory_order_relaxed);
	atomic_store_explicit(&y, a, memory_order_relaxed);
	return NULL;
}

int main()
{
	pthread_t t1, t2;

	pthread_create(&t1, NULL, thread_1, NULL);
	pthread_create(&t2, NULL, thread_2, NULL);

	pthread_join(t1, NULL);
	pthread_join(t2, NULL);

	return 0;
}
