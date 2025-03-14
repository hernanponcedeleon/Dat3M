#include <pthread.h>
#include <assert.h>
#include <stdatomic.h>

/* 
==============================================================
                        futex.h                       
==============================================================
*/

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

/* 
==============================================================
                        mutex.h                       
==============================================================
*/

typedef atomic_int mutex_t;

static inline void mutex_init(mutex_t *m)
{
    atomic_init(m, 0);
}

static inline int mutex_lock_fastpath(mutex_t *m)
{
    int r = 0;
    return atomic_compare_exchange_strong_explicit(m, &r, 1,
                               memory_order_acquire,
                               memory_order_acquire);
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


/* 
==============================================================
                        Client code                       
==============================================================
*/

#ifndef NTHREADS
#define NTHREADS 3
#endif

mutex_t mutex;
int sum = 0;

void *thread_n(void *arg)
{
    mutex_lock(&mutex);
    sum++;
    mutex_unlock(&mutex);
    return NULL;
}

int main()
{
    pthread_t t[NTHREADS];

    mutex_init(&mutex);

    for (int i = 0; i < NTHREADS; i++)
        pthread_create(&t[i], 0, thread_n, 0);

    for (int i = 0; i < NTHREADS; i++)
        pthread_join(t[i], 0);

    assert(sum == NTHREADS);

    return 0;
}
