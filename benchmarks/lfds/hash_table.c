#include "hash_table.h"
#include <pthread.h>
#include <assert.h>

#ifndef SETTERS
#define SETTERS 2
#endif

#ifndef GETTERS
#define GETTERS 2
#endif

#define NTHREADS (SETTERS + GETTERS)

atomic_int x;
int a,b;

// The hash_table is resilient against memory reordering, but externally, the
// caller may still need to enforce memory ordering using fence instructions. 
// For example, if you publicize the availability of some data to other threads 
// by storing a flag in the collection (MP pattern), you must place release 
// semantics on that store by issuing a release fence immediately beforehand.

void *thread_1(void *unused)
{
	atomic_store_explicit(&x, 1, memory_order_relaxed);
#ifndef FAIL
	atomic_thread_fence(memory_order_release);
#endif
	set(1, 1);
	return NULL;
}

void *thread_2(void *unused)
{
	a = get(1);
	atomic_thread_fence(memory_order_acquire);
	b = atomic_load_explicit(&x, memory_order_relaxed);
	return NULL;
}

int main()
{
	pthread_t t1, t2;

	pthread_create(&t1, NULL, thread_1, NULL);
	pthread_create(&t2, NULL, thread_2, NULL);

	pthread_join(t1, NULL);
	pthread_join(t2, NULL);

	assert(!(a == 1 && b == 0));

	return 0;
}