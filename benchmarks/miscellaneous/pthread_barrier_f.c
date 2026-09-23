#include <pthread.h>
#include <assert.h>
#include <stdint.h>

// Writes of other threads are only guaranteed to be visible after the barrier (the assertion can fail).

pthread_barrier_t barrier;
int data[2];

void *worker(void *arg)
{
    int i = (int)(intptr_t)arg;
    data[i] = 1;
    assert(data[1 - i] == 1);
    pthread_barrier_wait(&barrier);
    return NULL;
}

int main()
{
    pthread_t t0, t1;
    pthread_barrier_init(&barrier, NULL, 2);
    pthread_create(&t0, NULL, worker, (void *)0);
    pthread_create(&t1, NULL, worker, (void *)1);
    pthread_join(t0, NULL);
    pthread_join(t1, NULL);
    return 0;
}
