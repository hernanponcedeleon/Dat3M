#include <stdlib.h>
#include <pthread.h>
#include <assert.h>
#include <lkmm.h>

int x, y;
spinlock_t lock_x, lock_y;

void *thread_1(void *arg)
{
	spin_lock(&lock_x);
	WRITE_ONCE(x, 2);
	spin_unlock(&lock_x);
	spin_lock(&lock_y);
	WRITE_ONCE(y, 1);
	spin_unlock(&lock_y);
	return NULL;
}

void *thread_2(void *arg)
{
	spin_lock(&lock_y);
	WRITE_ONCE(y, 2);
	spin_unlock(&lock_y);
	spin_lock(&lock_x);
	WRITE_ONCE(x, 1);
	spin_unlock(&lock_x);
	return NULL;
}

int main()
{
	pthread_t t1, t2;

	pthread_create(&t1, NULL, thread_1, NULL);
	pthread_create(&t2, NULL, thread_2, NULL);
	
	pthread_join(t1, NULL);
	pthread_join(t2, NULL);

	assert(!(READ_ONCE(x)==2 && READ_ONCE(y)==2));

	return 0;
}
