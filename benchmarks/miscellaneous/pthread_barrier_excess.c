#include <pthread.h>
#include <assert.h>
#include <stdatomic.h>

// Callers beyond the count of a barrier belong to its next phase and must not pass with the current one.

pthread_barrier_t barrier;
atomic_int passed;

void *worker(void *arg)
{
    pthread_barrier_wait(&barrier);
    assert(atomic_fetch_add(&passed, 1) < 2);
    return NULL;
}

int main()
{
    pthread_t t0, t1, t2;
    pthread_barrier_init(&barrier, NULL, 2);
    pthread_create(&t0, NULL, worker, NULL);
    pthread_create(&t1, NULL, worker, NULL);
    pthread_create(&t2, NULL, worker, NULL);
    return 0;
}
