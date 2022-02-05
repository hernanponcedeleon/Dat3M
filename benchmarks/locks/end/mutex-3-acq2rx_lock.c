#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <pthread.h>
#include <stdatomic.h>
#include <assert.h>

#define ITERS 1

// futex.h
//
static atomic_int sig;

static inline void __futex_wait(atomic_int *m, int v)
{
    int s = atomic_load_explicit(&sig, memory_order_acquire);
    if (atomic_load_explicit(m, memory_order_acquire) != v)
        return;

    while (atomic_load_explicit(&sig, memory_order_acquire) == s)
        ;
}

static inline void __futex_wake(atomic_int *m, int v)
{
    atomic_fetch_add_explicit(&sig, 1, memory_order_release);
}

// mutex.h
//
typedef atomic_int mutex_t;

static inline void mutex_init(mutex_t *m);
static inline int mutex_lock_fastpath(mutex_t *m);
static inline int mutex_lock_try_acquire(mutex_t *m);
static inline void mutex_lock(mutex_t *m);
static inline int mutex_unlock_fastpath(mutex_t *m);
static inline void mutex_unlock(mutex_t *m);

// mutex.c
//
static inline void mutex_init(mutex_t *m)
{
    atomic_init(m, 0);
}

static inline int mutex_lock_fastpath(mutex_t *m)
{
    int r = 0;
    return atomic_compare_exchange_strong_explicit(m, &r, 1,
                               memory_order_relaxed,
                               memory_order_relaxed);
}

static inline int mutex_lock_try_acquire(mutex_t *m)
{
    int r = 0;
    return atomic_compare_exchange_strong_explicit(m, &r, 2,
                               memory_order_acquire,
                               memory_order_acquire);
}

static inline void mutex_lock(mutex_t *m)
{
    if (mutex_lock_fastpath(m))
        return;

    while (1) {
        int r = 1;
        atomic_compare_exchange_strong_explicit(m, &r, 2,
                            memory_order_relaxed,
                            memory_order_relaxed);
        __futex_wait(m, 2);
        if (mutex_lock_try_acquire(m))
            return;
    }
}

static inline int mutex_unlock_fastpath(mutex_t *m)
{
    int r = 1;
    return atomic_compare_exchange_strong_explicit(m, &r, 0,
                               memory_order_release,
                               memory_order_release);
}

static inline void mutex_unlock(mutex_t *m)
{
    if (mutex_unlock_fastpath(m))
        return;

    atomic_store_explicit(m, 0, memory_order_release);
    __futex_wake(m, 1);
}

// main.c
//
int shared;
int sum;
mutex_t mutex;

void *thread_n(void *arg)
{
    intptr_t index = ((intptr_t) arg);

    int rpt = ITERS;
again:

    mutex_lock(&mutex);
    shared = index;
    int r = shared;
    assert(r == index);
    sum++;
    mutex_unlock(&mutex);
    
    if (--rpt) goto again;

    return NULL;
}

// variant
//
int main()
{
    pthread_t t0, t1, t2;

    pthread_create(&t0, NULL, thread_n, (void *) 0);
    pthread_create(&t1, NULL, thread_n, (void *) 1);
    pthread_create(&t2, NULL, thread_n, (void *) 2);

    pthread_join(t0, 0);
    pthread_join(t1, 0);
    pthread_join(t2, 0);

    assert(sum == 3 * ITERS);

    return 0;
}
