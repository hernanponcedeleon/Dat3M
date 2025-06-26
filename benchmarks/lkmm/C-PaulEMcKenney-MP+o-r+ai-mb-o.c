#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <pthread.h>
#include <lkmm.h>
#include <assert.h>

atomic_t x, y;
int r0,r1;

void *thread_1(void *arg)
{
	atomic_set(&x, 1);
	r0 = atomic_xchg_release(&y, 5);
	return NULL;
}

void *thread_2(void *arg)
{
	atomic_inc(&y);
	smp_mb();
	r1 = atomic_read(&x);
	return NULL;
}

int main()
{
    pthread_t t1, t2;

    pthread_create(&t1, NULL, thread_1, NULL);
    pthread_create(&t2, NULL, thread_2, NULL);

    pthread_join(t1, 0);
    pthread_join(t2, 0);

    assert(!(r0==0 && r1==0));

    return 0;
}
