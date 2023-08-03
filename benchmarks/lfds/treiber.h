#include <stdatomic.h>
#include <stdlib.h>

#ifdef FAIL
#define CAS(ptr, expected, desired) (atomic_compare_exchange_strong_explicit(ptr, expected, desired, __ATOMIC_RELAXED, __ATOMIC_RELAXED))
#else
#define CAS(ptr, expected, desired) (atomic_compare_exchange_strong_explicit(ptr, expected, desired, __ATOMIC_ACQ_REL, __ATOMIC_RELAXED))
#endif

#define EMPTY -1

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