#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <pthread.h>
#include <stdatomic.h>
#include <assert.h>

#ifdef ACQ2RX
#define mo_lock memory_order_relaxed
#else
#define mo_lock memory_order_acquire
#endif
#ifdef REL2RX
#define mo_unlock memory_order_relaxed
#else
#define mo_unlock memory_order_release
#endif

// linuxrwlocks.c
//

#define RW_LOCK_BIAS            0x00100000

/** Example implementation of linux rw lock along with 2 thread test
 *  driver... */
typedef union {
    atomic_int lock;
} rwlock_t;

static inline int read_can_lock(rwlock_t *lock)
{
    return atomic_load_explicit(&lock->lock, memory_order_relaxed) > 0;
}

static inline int write_can_lock(rwlock_t *lock)
{
    return atomic_load_explicit(&lock->lock, memory_order_relaxed) == RW_LOCK_BIAS;
}

static inline void read_lock(rwlock_t *rw)
{
    int priorvalue = atomic_fetch_sub_explicit(&rw->lock, 1, mo_lock);
    while (priorvalue <= 0) {
        atomic_fetch_add_explicit(&rw->lock, 1, memory_order_relaxed);
        while (atomic_load_explicit(&rw->lock, memory_order_relaxed) <= 0)
            ; //thrd_yield();
        priorvalue = atomic_fetch_sub_explicit(&rw->lock, 1, memory_order_acquire);
    }
}

static inline void write_lock(rwlock_t *rw)
{
    int priorvalue = atomic_fetch_sub_explicit(&rw->lock, RW_LOCK_BIAS, memory_order_acquire);
    while (priorvalue != RW_LOCK_BIAS) {
        atomic_fetch_add_explicit(&rw->lock, RW_LOCK_BIAS, memory_order_relaxed);
        while (atomic_load_explicit(&rw->lock, memory_order_relaxed) != RW_LOCK_BIAS)
            ; //thrd_yield();
        priorvalue = atomic_fetch_sub_explicit(&rw->lock, RW_LOCK_BIAS, memory_order_acquire);
    }
}

static inline int read_trylock(rwlock_t *rw)
{
    int priorvalue = atomic_fetch_sub_explicit(&rw->lock, 1, memory_order_acquire);
    if (priorvalue > 0)
        return 1;

    atomic_fetch_add_explicit(&rw->lock, 1, memory_order_relaxed);
    return 0;
}

static inline int write_trylock(rwlock_t *rw)
{
    int priorvalue = atomic_fetch_sub_explicit(&rw->lock, RW_LOCK_BIAS, memory_order_acquire);
    if (priorvalue == RW_LOCK_BIAS)
        return 1;

    atomic_fetch_add_explicit(&rw->lock, RW_LOCK_BIAS, memory_order_relaxed);
    return 0;
}

static inline void read_unlock(rwlock_t *rw)
{
    atomic_fetch_add_explicit(&rw->lock, 1, memory_order_release);
}

static inline void write_unlock(rwlock_t *rw)
{
    atomic_fetch_add_explicit(&rw->lock, RW_LOCK_BIAS, mo_unlock);
}

rwlock_t mylock;
int shareddata;
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
    shareddata = 2;
    assert(shareddata == 2);
    sum++;
    write_unlock(&mylock);

    return NULL;
}

// variant
//
int main()
{
    pthread_t W0, R0, RW0;

    atomic_init(&mylock.lock, RW_LOCK_BIAS);
    
    pthread_create(&W0, NULL, threadW, NULL);
    pthread_create(&R0, NULL, threadR, NULL);
    pthread_create(&RW0, NULL, threadRW, NULL);

    pthread_join(W0, 0);
    pthread_join(R0, 0);
    pthread_join(RW0, 0);

    // Only write threads increment sum
    assert(sum == 2);

    return 0;
}
