#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>
#include <stdlib.h>

// Adapted from "Nhat Minh Lê, Antoniu Pop, Albert Cohen, Francesco Zappa Nardelli:
// Correct and efficient work-stealing for weak memory models. PPOPP 2013."

typedef struct {
    atomic_int size;
    atomic_int buffer[];
} Array;

typedef struct {
    atomic_int top, bottom;
    _Atomic(Array *) array;
} Deque;

_Bool empty(Deque *q) {
    size_t b = atomic_load_explicit(&q->bottom, memory_order_relaxed);
    size_t t = atomic_load_explicit(&q->top, memory_order_relaxed);
    return b <= t;
}

Deque *Deque_new(atomic_int size) {
    
    /* allocate list */
    Deque *the_queue = malloc(sizeof(Deque));
    Array *the_array = malloc(sizeof(Array));

    atomic_int b[]={};
    atomic_store_explicit(&the_array->size, memory_order_relaxed, size);
    atomic_store_explicit(&the_array->buffer, memory_order_relaxed, b);
    
    atomic_store_explicit(&the_queue->bottom, memory_order_relaxed, 0);
    atomic_store_explicit(&the_queue->top, memory_order_relaxed, 0);
    atomic_store_explicit(&the_queue->array, memory_order_relaxed, the_array);
    
    return the_queue;
}

int take(Deque *q) {
    size_t b = atomic_load_explicit(&q->bottom, memory_order_relaxed) - 1;
    Array *a = atomic_load_explicit(&q->array, memory_order_relaxed);
    atomic_store_explicit(&q->bottom, b, memory_order_relaxed);
    atomic_thread_fence(memory_order_seq_cst);
    size_t t = atomic_load_explicit(&q->top, memory_order_relaxed);
    int x;
    if (t <= b) {
        /* Non-empty queue. */
        x = atomic_load_explicit(&a->buffer[b % a->size], memory_order_relaxed);
        if (t == b) {
            /* Single last element in queue. */
            if (!atomic_compare_exchange_strong_explicit(&q->top, &t, t + 1, memory_order_seq_cst, memory_order_relaxed)) {
                /* Failed race. */
                /* -1 == EMPTY */
                x = -1;
            }
            atomic_store_explicit(&q->bottom, b + 1, memory_order_relaxed); }
    } else {
        /* Empty queue. */
        /* -1 == EMPTY */
        x = -1;
        atomic_store_explicit(&q->bottom, b + 1, memory_order_relaxed);
    }
    return x;
}

void push(Deque *q, int x) {
    size_t b = atomic_load_explicit(&q->bottom, memory_order_relaxed);
    size_t t = atomic_load_explicit(&q->top, memory_order_acquire);
    Array *a = atomic_load_explicit(&q->array, memory_order_relaxed);
    if (b - t > a->size - 1) {
        /* Full queue. */
//        resize(q);
        a = atomic_load_explicit(&q->array, memory_order_relaxed);
    }
    atomic_store_explicit(&a->buffer[b % a->size], x, memory_order_relaxed);
    atomic_thread_fence(memory_order_release);
    atomic_store_explicit(&q->bottom, b + 1, memory_order_relaxed);
}

int steal(Deque *q) {
    size_t t = atomic_load_explicit(&q->top, memory_order_acquire);
    atomic_thread_fence(memory_order_seq_cst);
    size_t b = atomic_load_explicit(&q->bottom, memory_order_acquire);
    /* -1 == EMPTY */
    int x = -1;
    if (t < b) {
        /* Non-empty queue. */
        Array *a = atomic_load_explicit(&q->array, memory_order_consume);
        x = atomic_load_explicit(&a->buffer[t % a->size], memory_order_relaxed);
        if (!atomic_compare_exchange_strong_explicit(&q->top, &t, t + 1, memory_order_seq_cst, memory_order_relaxed)) {
            /* Failed race. */
            /* -2 == ABORT */
            return -2;
        }
    }
    return x;
}

static Deque *the_queue;

void *owner(void *arg)
{
    intptr_t index = ((intptr_t) arg);
    int sum = 0;
    
    push(the_queue, index);
    push(the_queue, index);
    push(the_queue, index);
    
    // dequeue while non-empty
    while(empty(the_queue)) {
        take(the_queue);
        sum++;
    }

    assert(sum==3);
    return NULL;
}

void *thief(void *arg)
{
    intptr_t index = ((intptr_t) arg);
    
    // dequeue while non-empty
    while(empty(the_queue)) {
        steal(the_queue);
    }

    return NULL;
}

int main()
{
    pthread_t t1, t2, t3;

    /* initialization of the list */
//    the_list = list_new();

    pthread_create(&t1, NULL, owner, (void *) 0);
    pthread_create(&t2, NULL, thief, (void *) 1);
    pthread_create(&t3, NULL, thief, (void *) 2);
    
    pthread_join(t1, 0);
    pthread_join(t2, 0);
    pthread_join(t3, 0);
    
//    assert(list_size(the_list) == 0);
    
    return 0;
}

