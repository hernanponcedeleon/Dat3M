#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <pthread.h>
#include <lkmm.h>
#include <assert.h>

// futex.h
//
static atomic_t sig;

static inline void __futex_wait(atomic_t *m, int v)
{
    int s = atomic_read_acquire(&sig);
    if (atomic_read_acquire(m) != v)
        return;

    while (atomic_read_acquire(&sig) == s)
        ;
}

static inline void __futex_wake(atomic_t *m, int v)
{
    atomic_fetch_add_release(1, &sig);
}

// mutex.h
//
typedef atomic_t mutex_t;

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
    atomic_set(m, 0);
}

static inline int mutex_lock_fastpath(mutex_t *m)
{
    int r = 0;
    return atomic_cmpxchg_acquire(m, r, 1);
}

static inline int mutex_lock_try_acquire(mutex_t *m)
{
    int r = 0;
    return atomic_cmpxchg_acquire(m, r, 2);
}

static inline void mutex_lock(mutex_t *m)
{
    if (mutex_lock_fastpath(m))
        return;

    while (1) {
        int r = 1;
        atomic_cmpxchg_relaxed(m, r, 2);
        __futex_wait(m, 2);
        if (mutex_lock_try_acquire(m))
            return;
    }
}

static inline int mutex_unlock_fastpath(mutex_t *m)
{
    int r = 1;
    return atomic_cmpxchg_release(m, r, 0);
}

static inline void mutex_unlock(mutex_t *m)
{
    if (mutex_unlock_fastpath(m))
        return;

    atomic_set_release(m, 0);
    __futex_wake(m, 1);
}

// main.c
//
int shared;
mutex_t mutex;
int sum = 0;

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
    pthread_t t0, t1, t2, t3;

    pthread_create(&t0, NULL, thread_n, (void *) 0);
    pthread_create(&t1, NULL, thread_n, (void *) 1);
    pthread_create(&t2, NULL, thread_n, (void *) 2);
    pthread_create(&t3, NULL, thread_n, (void *) 3);
    
    pthread_join(t0, 0);
    pthread_join(t1, 0);
    pthread_join(t2, 0);
    pthread_join(t3, 0);
    
    assert(sum == 4);
    
    return 0;
}
