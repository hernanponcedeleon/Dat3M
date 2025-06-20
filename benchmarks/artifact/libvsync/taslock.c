#include <pthread.h>
#include <tas.h>
#include <assert.h>

#ifndef NTHREADS
#define NTHREADS 3
#endif

int shared;
taslock_t lock;
int sum = 0;

void *thread_n(void *arg)
{
    intptr_t index = ((intptr_t) arg);

    taslock_acquire(&lock);
    shared = index;
    int r = shared;
    assert(r == index);
    sum++;
    taslock_release(&lock);
    return NULL;
}

void *thread_fails_to_release(void *arg)
{
    intptr_t index = ((intptr_t) arg);

    taslock_acquire(&lock);
    return NULL;
}

int main()
{
    pthread_t t[NTHREADS+1];

    taslock_init(&lock);

    for (int i = 0; i < NTHREADS; i++)
        pthread_create(&t[i], 0, thread_n, (void *)(size_t)i);
    pthread_create(&t[NTHREADS], 0, thread_n, (void *)(size_t)NTHREADS);

    for (int i = 0; i < NTHREADS; i++)
        pthread_join(t[i], 0);
    pthread_join(t[NTHREADS], 0);

    assert(sum == NTHREADS);

    return 0;
}
