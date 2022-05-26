#include <stdlib.h>
#include <pthread.h>
#include <lkmm.h>
#include <assert.h>
#include <rcu.h>

int x;
int y;

int r_x;
int r_y;

void *P0(void *arg)
{
    tid = (intptr_t)arg;
	rcu_read_lock();
	WRITE_ONCE(x, 1);
	WRITE_ONCE(y, 1);
	rcu_read_unlock();
	return NULL;
}

void *P1(void *arg)
{
    tid = (intptr_t)arg;
	r_x = READ_ONCE(x);
	synchronize_rcu();
	r_y = READ_ONCE(y);
	return NULL;
}


int main()
{
	pthread_t t1, t2;

	pthread_create(&t1, NULL, P0, 0);
	pthread_create(&t2, NULL, P1, 1);

	pthread_join(t1, NULL);
	pthread_join(t2, NULL);

	assert(!(r_x == 1 && r_y == 0));

	return 0;
}
