#include <pthread.h>
#include <assert.h>

// A thread cannot complete the phases of a barrier on its own.

pthread_barrier_t barrier;

int main()
{
    pthread_barrier_init(&barrier, NULL, 2);
    pthread_barrier_wait(&barrier);
    pthread_barrier_wait(&barrier);
    assert(0);
    return 0;
}
