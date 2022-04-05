#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <pthread.h>
#include <lkmm.h>
#include <assert.h>

// ticketlock.h
//
struct ticketlock_s {
    atomic_t next;
    atomic_t owner;
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
    atomic_set(&l->next, 0);
    atomic_set(&l->owner, 0);
}

static inline int get_next_ticket(struct ticketlock_s *l)
{
    return atomic_fetch_add_relaxed(1, &l->next);
}

static inline void await_for_ticket(struct ticketlock_s *l, int ticket)
{
    while (atomic_read_acquire(&l->owner) != ticket)
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
    int o = atomic_read_acquire(&l->owner);
    int n = atomic_cmpxchg_relaxed(&l->next, &o, o + 1);
    return n == o;
}

static inline void ticketlock_release(struct ticketlock_s *l)
{
    int owner = atomic_read(&l->owner);
    atomic_set_release(&l->owner, owner + 1);
}

// main.c
//
int shared;
ticketlock_t lock;
int sum = 0;

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
    pthread_t t0, t1, t2, t3, t4, t5;

    ticketlock_init(&lock);
    
    pthread_create(&t0, NULL, thread_n, (void *) 0);
    pthread_create(&t1, NULL, thread_n, (void *) 1);
    pthread_create(&t2, NULL, thread_n, (void *) 2);
    pthread_create(&t3, NULL, thread_n, (void *) 3);
    pthread_create(&t4, NULL, thread_n, (void *) 4);
    pthread_create(&t5, NULL, thread_n, (void *) 5);

    pthread_join(t0, 0);
    pthread_join(t1, 0);
    pthread_join(t2, 0);
    pthread_join(t3, 0);
    pthread_join(t4, 0);
    pthread_join(t5, 0);

    assert(sum == 6);
    
    return 0;
}
