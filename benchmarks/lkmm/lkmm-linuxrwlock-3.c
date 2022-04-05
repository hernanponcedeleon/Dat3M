#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <pthread.h>
#include <lkmm.h>
#include <assert.h>

// linuxrwlocks.c
//

#define RW_LOCK_BIAS            0x00100000

/** Example implementation of linux rw lock along with 2 thread test
 *  driver... */
typedef union {
    atomic_t lock;
} rwlock_t;

static inline int read_can_lock(rwlock_t *lock)
{
    return atomic_read(&lock->lock) > 0;
}

static inline int write_can_lock(rwlock_t *lock)
{
    return atomic_read(&lock->lock) == RW_LOCK_BIAS;
}

static inline void read_lock(rwlock_t *rw)
{
    int priorvalue = atomic_fetch_sub_acquire(1, &rw->lock);
    while (priorvalue <= 0) {
        atomic_fetch_add_relaxed(1, &rw->lock);
        while (atomic_read(&rw->lock) <= 0)
            ; //thrd_yield();
        priorvalue = atomic_fetch_sub_acquire(1, &rw->lock);
    }
}

static inline void write_lock(rwlock_t *rw)
{
    int priorvalue = atomic_fetch_sub_acquire(RW_LOCK_BIAS, &rw->lock);
    while (priorvalue != RW_LOCK_BIAS) {
        atomic_fetch_add_relaxed(RW_LOCK_BIAS, &rw->lock);
        while (atomic_read(&rw->lock) != RW_LOCK_BIAS)
            ; //thrd_yield();
        priorvalue = atomic_fetch_sub_acquire(RW_LOCK_BIAS, &rw->lock);
    }
}

static inline int read_trylock(rwlock_t *rw)
{
    int priorvalue = atomic_fetch_sub_acquire(1, &rw->lock);
    if (priorvalue > 0)
        return 1;

    atomic_fetch_add_relaxed(1, &rw->lock);
    return 0;
}

static inline int write_trylock(rwlock_t *rw)
{
    int priorvalue = atomic_fetch_sub_acquire(RW_LOCK_BIAS, &rw->lock);
    if (priorvalue == RW_LOCK_BIAS)
        return 1;

    atomic_fetch_add_relaxed(RW_LOCK_BIAS, &rw->lock);
    return 0;
}

static inline void read_unlock(rwlock_t *rw)
{
    atomic_fetch_add_release(1, &rw->lock);
}

static inline void write_unlock(rwlock_t *rw)
{
    atomic_fetch_add_release(RW_LOCK_BIAS, &rw->lock);
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
    for (int i = 0; i < 2; i++) {
        if ((i % 2) == 0) {
            read_lock(&mylock);
            int r = shareddata;
            assert(r == shareddata);
            read_unlock(&mylock);
        } else {
            write_lock(&mylock);
            shareddata = i;
            assert(shareddata == i);
            sum++;
            write_unlock(&mylock);
        }
    }
    return NULL;
}

// variant
//
int main()
{
    pthread_t W0, R0, RW0;

    atomic_set(&mylock.lock, RW_LOCK_BIAS);
    
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
