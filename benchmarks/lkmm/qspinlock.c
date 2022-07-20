#include <stdlib.h>
#include <pthread.h>
#include <assert.h>
#include <lkmm.h>

int x;
atomic_t y;

void *thread_1(void *unused)
{
	WRITE_ONCE(x, 1);
	atomic_set_release(&y, 1);
	return NULL;
}

void *thread_2(void *unused)
{
	atomic_fetch_or_relaxed(2, &y); 
	return NULL;
}

void *thread_3(void *unused)
{
	 if (atomic_read(&y) & 1) {
	 	smp_rmb();
	 	assert (READ_ONCE(x) == 1);	 	
	 }
	return NULL;
}

int main()
{
	pthread_t t1, t2, t3;

	if (pthread_create(&t1, NULL, thread_1, NULL));
	if (pthread_create(&t2, NULL, thread_2, NULL));
	if (pthread_create(&t3, NULL, thread_3, NULL));

	if (pthread_join(t1, NULL));
	if (pthread_join(t2, NULL));
	if (pthread_join(t3, NULL));

	return 0;
}
