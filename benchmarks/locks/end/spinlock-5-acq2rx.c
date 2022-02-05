#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <pthread.h>
#include <stdatomic.h>
#include <assert.h>

#define ITERS 1

// spinlock.h
//
struct spinlock_s {
    atomic_int lock;
};

typedef struct spinlock_s spinlock_t;

static inline void spinlock_init(struct spinlock_s *l);
static inline void spinlock_acquire(struct spinlock_s *l);
static inline int spinlock_tryacquire(struct spinlock_s *l);
static inline void spinlock_release(struct spinlock_s *l);

// spinlock.c
//
static inline void spinlock_init(struct spinlock_s *l)
{
    atomic_init(&l->lock, 0);
}

static inline void await_for_lock(struct spinlock_s *l)
{
    while (atomic_load_explicit(&l->lock, memory_order_relaxed) != 0)
        ;
    return;
}

static inline int try_get_lock(struct spinlock_s *l)
{
    int val = 0;
    return atomic_compare_exchange_strong_explicit(&l->lock, &val, 1,
                               memory_order_relaxed,
                               memory_order_relaxed);
}

static inline void spinlock_acquire(struct spinlock_s *l)
{
    do {
        await_for_lock(l);
    } while(!try_get_lock(l));
    return;
}

static inline int spinlock_tryacquire(struct spinlock_s *l)
{
    return try_get_lock(l);
}

static inline void spinlock_release(struct spinlock_s *l)
{
    atomic_store_explicit(&l->lock, 0, memory_order_release);
}

// main.c
//
int shared;
int sum;
spinlock_t lock;

void *thread_n(void *arg)
{
    intptr_t index = ((intptr_t) arg);

    int rpt = ITERS;
again:

    spinlock_acquire(&lock);
    shared = index;
    int r = shared;
    assert(r == index);
    sum++;
    spinlock_release(&lock);
    
    if (--rpt) goto again;

    return NULL;
}

// variant
//
int main()
{
    pthread_t t0, t1, t2, t3, t4;

    spinlock_init(&lock);
    pthread_create(&t0, NULL, thread_n, (void *) 0);
    pthread_create(&t1, NULL, thread_n, (void *) 1);
    pthread_create(&t2, NULL, thread_n, (void *) 2);
    pthread_create(&t3, NULL, thread_n, (void *) 3);
    pthread_create(&t4, NULL, thread_n, (void *) 4);

    pthread_join(t0, 0);
    pthread_join(t1, 0);
    pthread_join(t2, 0);
    pthread_join(t3, 0);
    pthread_join(t4, 0);

    assert(sum == 5 * ITERS);

    return 0;
}
