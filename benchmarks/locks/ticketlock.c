#include <pthread.h>
#include "ticketlock.h"
#include <assert.h>

#ifndef NTHREADS
#define NTHREADS 3
#endif

int shared;
ticketlock_t lock;
int sum = 0;

void *thread_n(void *arg)
{
    intptr_t index = ((intptr_t) arg);

    ticketlock_acquire(&lock);
    shared = index;
    int r = shared;
    assert(r == index);
    sum++;
    ticketlock_release(&lock);
    return NULL;
}

int main()
{
    pthread_t t[NTHREADS];

    ticketlock_init(&lock);

    for (int i = 0; i < NTHREADS; i++)
        pthread_create(&t[i], 0, thread_n, (void *)(size_t)i);

    for (int i = 0; i < NTHREADS; i++)
        pthread_join(t[i], 0);

    assert(sum == NTHREADS);

    return 0;
}
