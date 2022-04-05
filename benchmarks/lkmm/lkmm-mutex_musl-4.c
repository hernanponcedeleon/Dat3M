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

// mutex_musl.h
//
typedef struct {
    atomic_t lock;
    atomic_t waiters;
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
    atomic_set(&m->lock, 0);
    atomic_set(&m->waiters, 0);
}

static inline int mutex_lock_fastpath(mutex_t *m)
{
    int r = 0;
    return atomic_cmpxchg_acquire(&m->lock, &r, 1);
}

static inline int mutex_lock_slowpath_check(mutex_t *m)
{
    int r = 0;
    return atomic_cmpxchg_acquire(&m->lock, &r, 1);
}

static inline void mutex_lock(mutex_t *m)
{

    if (mutex_lock_fastpath(m))
        return;

    while (mutex_lock_slowpath_check(m) == 0) {
        atomic_fetch_add_relaxed(1, &m->waiters);
        int r = 1;
        if (!atomic_cmpxchg_relaxed(&m->lock, &r, 2))
        __futex_wait(&m->lock, 2);
        atomic_fetch_sub_relaxed(1, &m->waiters);
    }
}

static inline void mutex_unlock(mutex_t *m)
{
    int old = atomic_xchg_release(&m->lock, 0);
    if (atomic_read(&m->waiters) > 0 || old != 1)
        __futex_wake(&m->lock, 1);
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
    mutex_init(&mutex);

    pthread_create(&t0, NULL, thread_n, (void *) 0);
    pthread_create(&t1, NULL, thread_n, (void *) 1);
    pthread_create(&t2, NULL, thread_n, (void *) 2);
    pthread_create(&t3, NULL, thread_n, (void *) 3);
    
    pthread_join(t0,0);
    pthread_join(t1,0);
    pthread_join(t2,0);
    pthread_join(t3,0);
    
    assert(sum == 4);

    return 0;
}
