#include <pthread.h>
#include <assert.h>

// A thread cannot complete a phase of a barrier on its own, even after completing an earlier phase with others.

pthread_barrier_t barrier;

void *worker(void *arg)
{
    pthread_barrier_wait(&barrier);
    pthread_barrier_wait(&barrier);
    assert(0);
    return NULL;
}

int main()
{
    pthread_t t;
    pthread_barrier_init(&barrier, NULL, 2);
    pthread_create(&t, NULL, worker, NULL);
    pthread_barrier_wait(&barrier);
    return 0;
}
