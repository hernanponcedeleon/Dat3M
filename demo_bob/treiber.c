#include <pthread.h>
#include <assert.h>
#include <stdatomic.h>
#include <stdlib.h>

#ifdef FAIL
#define CAS(ptr, expected, desired) (atomic_compare_exchange_strong_explicit(ptr, expected, desired, __ATOMIC_RELAXED, __ATOMIC_RELAXED))
#else
#define CAS(ptr, expected, desired) (atomic_compare_exchange_strong_explicit(ptr, expected, desired, __ATOMIC_ACQ_REL, __ATOMIC_RELAXED))
#endif

#define EMPTY -1

/*
==============================================================
                        treiber.h
==============================================================
*/

typedef struct Node {
    int val;
    _Atomic(struct Node*) next;
} Node;

struct {
    _Atomic(Node*) node;
} TOP;

void init() {
    atomic_init(&TOP.node, NULL);
}

void push(int e) {
    Node *y, *n;
    y = malloc(sizeof (Node));
    y->val = e;

    while(1) {
        n = atomic_load_explicit(&TOP.node, __ATOMIC_ACQUIRE);
        atomic_store_explicit(&y->next, n, __ATOMIC_RELAXED);

        if (CAS(&TOP.node, &n, y)) {
            break;
        }
    }
}

int pop() {
    Node *y, *z;

    while (1) {
        y = atomic_load_explicit(&TOP.node, __ATOMIC_ACQUIRE);
        if (y == NULL) {
            return EMPTY;
        } else {
            z = atomic_load_explicit(&y->next, __ATOMIC_ACQUIRE);
            if (CAS(&TOP.node, &y, z)) {
                // retire(y)
                break;
            }
        }
    }
    return y->val;
}

/* 
==============================================================
                        Client code                       
==============================================================
*/

#ifndef NTHREADS
#define NTHREADS 3
#endif

void *worker(void *arg)
{

    intptr_t index = ((intptr_t) arg);

    push(index);
    int r = pop();

    assert(r != EMPTY);

    return NULL;
}

int main()
{
    pthread_t t[NTHREADS];

    init();

    for (int i = 0; i < NTHREADS; i++)
        pthread_create(&t[i], 0, worker, (void *)(size_t)i);

    for (int i = 0; i < NTHREADS; i++)
        pthread_join(t[i], 0);

    int r = pop();
    assert(r == EMPTY);

    return 0;
}
