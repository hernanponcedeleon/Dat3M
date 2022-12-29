#include <stdatomic.h>
#include <stdbool.h>

#ifndef LEN
#define LEN 10
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
                                                                 memory_order_relaxed,
                                                                 memory_order_relaxed);
    atomic_store_explicit(&deq->bottom, b, memory_order_relaxed);
    return (is_successful ? 0 : -2); // success or lost
}

int try_steal(struct Deque *deq, int N, int* data)
{
    int t = atomic_load_explicit(&deq->top, memory_order_relaxed);
    atomic_thread_fence(memory_order_seq_cst);
    int b = atomic_load_explicit(&deq->bottom, memory_order_relaxed);

    if ((b - t) <= 0) {
        return -1; // empty
    }

    *data = deq->buffer[t % N];

    bool is_successful = atomic_compare_exchange_strong_explicit(&deq->top, &t, t + 1,
                                                                 memory_order_relaxed,
                                                                 memory_order_relaxed);
    return (is_successful ? 0 : -2); // success or lost
}
