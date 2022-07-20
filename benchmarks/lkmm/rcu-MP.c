#include <stdlib.h>
#include <pthread.h>
#include <lkmm.h>
#include <assert.h>
#include <rcu.h>

int x;
int y;

void *P0(void *arg)
{
	WRITE_ONCE(x, 1);
	synchronize_rcu();
	WRITE_ONCE(y, 1);
	return NULL;
}

void *P1(void *arg)
{
	rcu_read_lock();
	int r_y = READ_ONCE(y);
	int r_x = READ_ONCE(x);
	rcu_read_unlock();
    assert(!(r_y == 1 && r_x == 0));
	return NULL;
}


int main()
{

    init_rcu();
    
	pthread_t t1, t2;

	pthread_create(&t1, NULL, P0, NULL);
	pthread_create(&t2, NULL, P1, NULL);

	return 0;
}
