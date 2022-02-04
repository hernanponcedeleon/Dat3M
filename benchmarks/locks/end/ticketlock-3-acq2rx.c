#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <pthread.h>
#include <stdatomic.h>
#include <assert.h>

// ticketlock.h
//
struct ticketlock_s {
    atomic_int next;
    atomic_int owner;
};
typedef struct ticketlock_s ticketlock_t;

static inline void ticketlock_init(struct ticketlock_s *l);
static inline void ticketlock_acquire(struct ticketlock_s *l);
static inline int ticketlock_tryacquire(struct ticketlock_s *l);
static inline void ticketlock_release(struct ticketlock_s *l);

// ticketlock.c
//
static inline void ticketlock_init(struct ticketlock_s *l)
{
    atomic_init(&l->next, 0);
    atomic_init(&l->owner, 0);
}

static inline int get_next_ticket(struct ticketlock_s *l)
{
    return atomic_fetch_add_explicit(&l->next, 1, memory_order_relaxed);
}

static inline void await_for_ticket(struct ticketlock_s *l, int ticket)
{
    while (atomic_load_explicit(&l->owner, memory_order_relaxed) != ticket)
        ;
}

static inline void ticketlock_acquire(struct ticketlock_s *l)
{
    int ticket = get_next_ticket(l);
    await_for_ticket(l, ticket);
}

// NOTE: Unused and wrong code!
static inline int ticketlock_tryacquire(struct ticketlock_s *l)
{
    int o = atomic_load_explicit(&l->owner, memory_order_acquire);
    int n = atomic_compare_exchange_strong_explicit(&l->next, &o, o + 1,
                            memory_order_relaxed,
                            memory_order_relaxed);
    return n == o;
}

static inline void ticketlock_release(struct ticketlock_s *l)
{
    int owner = atomic_load_explicit(&l->owner, memory_order_relaxed);
    atomic_store_explicit(&l->owner, owner + 1, memory_order_release);
}

// main.c
//
int shared;
int sum;
ticketlock_t lock;

void *thread_n(void *arg)
{
    intptr_t index = ((intptr_t) arg);

    ticketlock_acquire(&lock);
    shared = index;
    int r = shared;
    assert(r == index);
    sum++;
    ticketlock_release(&lock);
    return NULL;
}

// variant
//
int main()
{
    pthread_t t0, t1, t2;

    ticketlock_init(&lock);
    
    pthread_create(&t0, NULL, thread_n, (void *) 0);
    pthread_create(&t1, NULL, thread_n, (void *) 1);
    pthread_create(&t2, NULL, thread_n, (void *) 2);

    pthread_join(t0, 0);
    pthread_join(t1, 0);
    pthread_join(t2, 0);

    assert(sum == 3);

    return 0;
}
