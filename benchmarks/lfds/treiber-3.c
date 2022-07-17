#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>
#include <stdlib.h>

#ifdef FAIL
#define CAS(ptr, expected, desired) (atomic_compare_exchange_strong_explicit(ptr, expected, desired, __ATOMIC_RELAXED, __ATOMIC_RELAXED))
#else
#define CAS(ptr, expected, desired) (atomic_compare_exchange_strong_explicit(ptr, expected, desired, __ATOMIC_ACQ_REL, __ATOMIC_RELAXED))
#endif
#define load(loc) (atomic_load_explicit(loc, __ATOMIC_ACQUIRE))
#define store(loc, val) (atomic_store_explicit(loc, val, __ATOMIC_RELEASE))
#define rx_load(loc) (atomic_load_explicit(loc, __ATOMIC_RELAXED))
#define rx_store(loc, val) (atomic_store_explicit(loc, val, __ATOMIC_RELAXED))

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
        n = load(&TOP.node);
        rx_store(&y->next, n);

        if (CAS(&TOP.node, &n, y)) {
            break;
        }
    }
}

int pop() {
    Node *y, *z;

    while (1) {
        y = load(&TOP.node);
        if (y == NULL) {
            return EMPTY;
        } else {
            z = load(&y->next);
            if (CAS(&TOP.node, &y, z)) {
                // retire(y)
                break;
            }
        }
    }
    return y->val;
}

// =========== Worker threads ==============

void *worker_1(void *unused)
{
	push(42);
    int r = pop();
    assert(r != EMPTY);
	return NULL;
}

void *worker_2(void *unused)
{
	push(41);
    int r = pop();
    assert(r != EMPTY);
	return NULL;
}

int main()
{
    pthread_t t1, t2, t3;

    init();

    pthread_create(&t1, NULL, worker_1, NULL);
    pthread_create(&t2, NULL, worker_2, NULL);
    pthread_create(&t3, NULL, worker_2, NULL);
    
    pthread_join(t1, NULL);
    pthread_join(t2, NULL);
    pthread_join(t3, NULL);
    
    int r = pop();
    assert(r == EMPTY);

  return 0;
}
