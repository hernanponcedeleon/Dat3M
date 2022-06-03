#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <pthread.h>
#include <lkmm.h>
#include <assert.h>

// ttaslock.h
//
struct ttaslock_s {
    atomic_t state;
};
typedef struct ttaslock_s ttaslock_t;

static inline void ttaslock_init(struct ttaslock_s *l);
static inline void ttaslock_acquire(struct ttaslock_s *l);
static inline void ttaslock_release(struct ttaslock_s *l);

// ttaslock.c
//
static inline void ttaslock_init(struct ttaslock_s *l)
{
    atomic_set(&l->state, 0);
}

static inline void await_for_lock(struct ttaslock_s *l)
{
    while (atomic_read(&l->state) != 0)
        ;
    return;
}

static inline int try_acquire(struct ttaslock_s *l)
{
    return atomic_xchg_acquire(&l->state, 1);
}

static inline void ttaslock_acquire(struct ttaslock_s *l)
{
    while (1) {
        await_for_lock(l);
        if (!try_acquire(l))
            return;
    }
}

static inline void ttaslock_release(struct ttaslock_s *l)
{
    atomic_set_release(&l->state, 0);
}

// main.c
//
int shared;
ttaslock_t lock;
int sum = 0;

void *thread_n(void *arg)
{
    intptr_t index = ((intptr_t) arg);

    ttaslock_acquire(&lock);
    shared = index;
    int r = shared;
    assert(r == index);
    sum++;
    ttaslock_release(&lock);
    return NULL;
}

// variant
//
int main()
{
    pthread_t t1, t2, t3, t4, t5;

    ttaslock_init(&lock);

    pthread_create(&t1, NULL, thread_n, (void *) 0);
    pthread_create(&t2, NULL, thread_n, (void *) 1);
    pthread_create(&t3, NULL, thread_n, (void *) 2);
    pthread_create(&t4, NULL, thread_n, (void *) 3);
    pthread_create(&t5, NULL, thread_n, (void *) 4);

    pthread_join(t1, 0);
    pthread_join(t2, 0);
    pthread_join(t3, 0);
    pthread_join(t4, 0);
    pthread_join(t5, 0);

    assert(sum == 5);

    return 0;
}
