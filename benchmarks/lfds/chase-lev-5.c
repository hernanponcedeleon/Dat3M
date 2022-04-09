#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>

// deque.h

#ifndef LEN
# define LEN 10
#endif

struct Deque {
    atomic_int bottom;
    atomic_int top;
    int buffer[LEN]; // in fact, it should be marked as atomic
    //due to the race between push and
    // steal.
};

int try_push(struct Deque *deq, int N, int data)
{
    int b = atomic_load_explicit(&deq->bottom, memory_order_relaxed);
    int t = atomic_load_explicit(&deq->top, memory_order_acquire);

    if ((b - t) >= N) {
        return -1; // full
    }

    deq->buffer[b % N] = data;
    atomic_store_explicit(&deq->bottom, b + 1, memory_order_release);
    return 0;
}

int try_pop(struct Deque *deq, int N, int *data)
{
    int b = atomic_load_explicit(&deq->bottom, memory_order_relaxed);
    atomic_store_explicit(&deq->bottom, b - 1, memory_order_relaxed);

    atomic_thread_fence(memory_order_seq_cst);

    int t = atomic_load_explicit(&deq->top, memory_order_relaxed);

    if ((b - t) <= 0) {
        atomic_store_explicit(&deq->bottom, b, memory_order_relaxed);
        return -1; // empty
    }

    *data = deq->buffer[(b - 1) % N];

    if ((b - t) > 1) {
        return 0;
    }

    // (b - t) = 1.
    bool is_successful = atomic_compare_exchange_strong_explicit(&deq->top, &t, t + 1,
                                memory_order_acq_rel,
                                memory_order_acq_rel);
    atomic_store_explicit(&deq->bottom, b, memory_order_relaxed);
    return (is_successful ? 0 : -2); // success or lost
}

int try_steal(struct Deque *deq, int N, int* data)
{
    int t = atomic_load_explicit(&deq->top, memory_order_relaxed);
    atomic_thread_fence(memory_order_seq_cst);
    int b = atomic_load_explicit(&deq->bottom, memory_order_acquire);

    if ((b - t) <= 0) {
        return -1; // empty
    }

    *data = deq->buffer[t % N];

    bool is_successful = atomic_compare_exchange_strong_explicit(&deq->top, &t, t + 1,
                                memory_order_release,
                                memory_order_release);
    return (is_successful ? 0 : -2); // success or lost
}


// chase-lev.c

#ifndef NUM
# define NUM 10
#endif

struct Deque deq;

void *owner(void *unused)
{
    int count = 0;
    try_push(&deq, NUM, count++);
    try_push(&deq, NUM, count++);
    try_push(&deq, NUM, count++);
    try_push(&deq, NUM, count++);
    try_push(&deq, NUM, count++);
    try_push(&deq, NUM, count++);

    int data;
    assert(try_pop(&deq, NUM, &data) >= 0);
    assert(try_pop(&deq, NUM, &data) >= 0);

    return NULL;
}

void *thief(void *unused)
{
    int data;
    try_steal(&deq, NUM, &data);
    return NULL;
}

int main()
{
	pthread_t t0, t1, t2, t3, t4;

	pthread_create(&t0, NULL, owner, NULL);
    pthread_create(&t1, NULL, thief, NULL);
    pthread_create(&t2, NULL, thief, NULL);
    pthread_create(&t3, NULL, thief, NULL);
    pthread_create(&t4, NULL, thief, NULL);
#ifdef FAIL
    pthread_t t5;
    pthread_create(&t5, NULL, thief, NULL);
#endif
    return 0;
}
