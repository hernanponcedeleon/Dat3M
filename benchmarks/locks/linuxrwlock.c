#include <pthread.h>
#include "linuxrwlock.h"
#include <assert.h>

#ifndef NRTHREADS
#define NRTHREADS 1
#endif

#ifndef NWTHREADS
#define NWTHREADS 1
#endif

#ifndef NRWTHREADS
#define NRWTHREADS 1
#endif

rwlock_t mylock;
// volatile is needed otherwise the compile can simplify the reader CS
int volatile shareddata;
int sum = 0;

void *threadR(void *arg)
{
    read_lock(&mylock);
    int r = shareddata;
    assert(r == shareddata);
    read_unlock(&mylock);

    return NULL;
}

void *threadW(void *arg)
{
    write_lock(&mylock);
    shareddata = 42;
    assert(42 == shareddata);
    sum++;
    write_unlock(&mylock);

    return NULL;
}

void *threadRW(void *arg)
{
    read_lock(&mylock);
    int r = shareddata;
    assert(r == shareddata);
    read_unlock(&mylock);

    write_lock(&mylock);
    shareddata = 42;
    assert(42 == shareddata);
    sum++;
    write_unlock(&mylock);

    return NULL;
}

int main()
{
    pthread_t r[NRTHREADS];
    pthread_t w[NWTHREADS];
    pthread_t rw[NRWTHREADS];

    atomic_init(&mylock.lock, RW_LOCK_BIAS);

    for (int i = 0; i < NRTHREADS; i++)
        pthread_create(&r[i], 0, threadR, NULL);
    for (int i = 0; i < NWTHREADS; i++)
        pthread_create(&w[i], 0, threadW, NULL);
    for (int i = 0; i < NRWTHREADS; i++)
        pthread_create(&rw[i], 0, threadRW, NULL);

    for (int i = 0; i < NRTHREADS; i++)
        pthread_join(r[i], 0);
    for (int i = 0; i < NWTHREADS; i++)
        pthread_join(w[i], 0);
    for (int i = 0; i < NRWTHREADS; i++)
        pthread_join(rw[i], 0);

    // Only write threads increment sum
    assert(sum == NWTHREADS + NWTHREADS);

    return 0;
}
