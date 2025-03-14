#include <stdlib.h>
#include <pthread.h>
#include <assert.h>
#include <lkmm.h>

int data;
atomic_t lock;

void *thread_1(void *unused)
{
	WRITE_ONCE(data, 1);
	atomic_set_release(&lock, 1);
	return NULL;
}

void *thread_2(void *unused)
{
	atomic_fetch_or_relaxed(2, &lock);
	return NULL;
}

void *thread_3(void *unused)
{
	 if (atomic_read(&lock) & 1) {
	 	smp_rmb();
	 	assert (READ_ONCE(data) == 1);
	 }
	return NULL;
}

int main()
{
	pthread_t t1, t2, t3;

	pthread_create(&t1, NULL, thread_1, NULL);
	pthread_create(&t2, NULL, thread_2, NULL);
	pthread_create(&t3, NULL, thread_3, NULL);

	pthread_join(t1, NULL);
	pthread_join(t2, NULL);
	pthread_join(t3, NULL);

	return 0;
}
