#include <pthread.h>
#include "clh_mutex.h"
#include <assert.h>

#ifndef NTHREADS
#define NTHREADS 3
#endif

int shared;
clh_mutex_t lock;
int sum = 0;

void *thread_n(void *arg)
{
    intptr_t index = ((intptr_t) arg);

    clh_mutex_lock(&lock);
    shared = index;
    int r = shared;
    assert(r == index);
    sum++;
    clh_mutex_unlock(&lock);
    return NULL;
}

int main()
{
    pthread_t t[NTHREADS];

    clh_mutex_init(&lock);

    for (int i = 0; i < NTHREADS; i++)
        pthread_create(&t[i], 0, thread_n, (void *)(size_t)i);

    for (int i = 0; i < NTHREADS; i++)
        pthread_join(t[i], 0);

    assert(sum == NTHREADS);

    clh_mutex_destroy(&lock);

    return 0;
}
