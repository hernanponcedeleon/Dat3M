#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <pthread.h>
#include <stdatomic.h>
#include <assert.h>

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
    atomic_fetch_add_explicit(&sig, 1, memory_order_relaxed);
}

// mutex_musl.h
//
typedef struct {
    atomic_int lock;
    atomic_int waiters;
} mutex_t;

static inline void mutex_init(mutex_t *m);
static inline int mutex_lock_fastpath(mutex_t *m);
static inline int mutex_lock_slowpath_check(mutex_t *m);
static inline void mutex_lock(mutex_t *m);
static inline void mutex_unlock(mutex_t *m);

// mutex_musl.c
//
static inline void mutex_init(mutex_t *m)
{
    atomic_init(&m->lock, 0);
    atomic_init(&m->waiters, 0);
}

static inline int mutex_lock_fastpath(mutex_t *m)
{
    int r = 0;
    return atomic_compare_exchange_strong_explicit(&m->lock, &r, 1,
                               memory_order_acquire,
                               memory_order_acquire);
}

static inline int mutex_lock_slowpath_check(mutex_t *m)
{
    int r = 0;
    return atomic_compare_exchange_strong_explicit(&m->lock, &r, 1,
                               memory_order_acquire,
                               memory_order_acquire);
}

static inline void mutex_lock(mutex_t *m)
{

    if (mutex_lock_fastpath(m))
        return;

    while (mutex_lock_slowpath_check(m) == 0) {
        atomic_fetch_add_explicit(&m->waiters, 1, memory_order_relaxed);
        int r = 1;
        if (!atomic_compare_exchange_strong_explicit(&m->lock, &r, 2,
                                 memory_order_relaxed,
                                 memory_order_relaxed))
        __futex_wait(&m->lock, 2);
        atomic_fetch_sub_explicit(&m->waiters, 1, memory_order_relaxed);
    }
}

static inline void mutex_unlock(mutex_t *m)
{
    int old = atomic_exchange_explicit(&m->lock, 0, memory_order_release);
    if (atomic_load_explicit(&m->waiters, memory_order_relaxed) > 0 || old != 1)
        __futex_wake(&m->lock, 1);
}


// main.c
//
int shared;
int sum;
mutex_t mutex;

void *thread_n(void *arg)
{
    intptr_t index = ((intptr_t) arg);

    mutex_lock(&mutex);
    shared = index;
    int r = shared;
    assert(r == index);
    sum++;
    mutex_unlock(&mutex);
    return NULL;
}

// variant
//
int main()
{
    pthread_t t0, t1, t2;
    mutex_init(&mutex);

    pthread_create(&t0, NULL, thread_n, (void *) 0);
    pthread_create(&t1, NULL, thread_n, (void *) 1);
    pthread_create(&t2, NULL, thread_n, (void *) 2);

    pthread_join(t0, 0);
    pthread_join(t1, 0);
    pthread_join(t2, 0);

    assert(sum == 3);

    return 0;
}
