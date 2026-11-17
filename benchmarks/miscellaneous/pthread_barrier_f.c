#include <pthread.h>
#include <assert.h>

// One of the threads passing a barrier is its serial thread (the assertion can fail).

pthread_barrier_t barrier;

void *worker(void *arg)
{
    assert(pthread_barrier_wait(&barrier) != PTHREAD_BARRIER_SERIAL_THREAD);
    return NULL;
}

int main()
{
    pthread_t t0, t1;
    pthread_barrier_init(&barrier, NULL, 2);
    pthread_create(&t0, NULL, worker, NULL);
    pthread_create(&t1, NULL, worker, NULL);
    pthread_join(t0, NULL);
    pthread_join(t1, NULL);
    return 0;
}
