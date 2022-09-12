#include <stdlib.h>
#include <pthread.h>
#include <assert.h>
#include <lkmm.h>

int y, z;
atomic_t x;

void *thread_1(void *unused)
{   
    // clear_pending_set_locked
    int r0 = atomic_fetch_add(2,&x) ;
}

void *thread_2(void *unused)
{
    // this store breaks liveness
    WRITE_ONCE(y, 1);
    // queued_spin_trylock
    int r0 = atomic_read(&x);
    // barrier after the initialisation of nodes
    smp_wmb();
    // xchg_tail
    int r1 = atomic_cmpxchg_relaxed(&x,r0,42);
    // link node into the waitqueue
    WRITE_ONCE(z, 1);
}

void *thread_3(void *unused)
{
    // node initialisation
    WRITE_ONCE(z, 2);
    // queued_spin_trylock
    int r0 = atomic_read(&x);
    // barrier after the initialisation of nodes
    smp_wmb();
    // if we read z==2 we expect to read this store
    WRITE_ONCE(y, 0);
    // xchg_tail
    int r1 = atomic_cmpxchg_relaxed(&x,r0,24);
    // spinloop
    while(READ_ONCE(y) == 1 && (READ_ONCE(z) == 2)) {}
}

int main()
{
	pthread_t t1, t2, t3;

	pthread_create(&t1, NULL, thread_1, NULL);
	pthread_create(&t2, NULL, thread_2, NULL);
	pthread_create(&t3, NULL, thread_3, NULL);

	return 0;
}
