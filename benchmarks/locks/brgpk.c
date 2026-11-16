#include <pthread.h>
#include <assert.h>

// Keep the middle path short to bound the state space (the paper uses 40).
#ifndef BRGPK_MID_ITERS
#define BRGPK_MID_ITERS 1
#endif
#include "brgpk.h"

#ifndef NTHREADS
#define NTHREADS 3
#endif

int shared;
brgpk_mutex_t lock;
struct brgpk_waiter waiters[NTHREADS];
int sum = 0;

void *thread_n(void *arg)
{
    intptr_t index = ((intptr_t) arg);
    // Owner ids must be non-zero and keep the contended bit clear.
    uintptr_t self = ((uintptr_t)index + 1) << 1;

    brgpk_mutex_enter(&lock, &waiters[index], self);
    shared = index;
    int r = shared;
    assert(r == index);
    sum++;
    brgpk_mutex_leave(&lock, self);
    return NULL;
}

int main()
{
    pthread_t t[NTHREADS];

    brgpk_mutex_init(&lock);

    for (int i = 0; i < NTHREADS; i++)
        pthread_create(&t[i], 0, thread_n, (void *)(size_t)i);

    for (int i = 0; i < NTHREADS; i++)
        pthread_join(t[i], 0);

    assert(sum == NTHREADS);

    return 0;
}
