#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>

extern void abort(void);

#define CAS(ptr, expected, desired) (atomic_compare_exchange_strong_explicit(ptr, expected, desired, __ATOMIC_ACQ_REL, __ATOMIC_RELAXED))
#define load(loc) (atomic_load_explicit(loc, __ATOMIC_ACQUIRE))
#define store(loc, val) (atomic_store_explicit(loc, val, __ATOMIC_RELEASE))
#define rx_load(loc) (atomic_load_explicit(loc, __ATOMIC_RELAXED))
#define rx_store(loc, val) (atomic_store_explicit(loc, val, __ATOMIC_RELAXED))

#define EMPTY -1

/*
extern void retire(Node* ptr);
*/

void reach_error() { assert(0); }

void __VERIFIER_assert(int expression) { if (!expression) { ERROR: {reach_error();abort();}}; return; }


typedef struct Node {
	int val;
	_Atomic(struct Node*) next;
} Node;

struct {
    _Atomic(Node*) node;
} TOP;

//NodePtr TOP;


void init() {
    atomic_init(&TOP.node, NULL);
}

void push(int e) {
    Node *y, *n;
    y = malloc(sizeof (Node));
    y->val = e;

    while(true) {
        n = load(&TOP.node);
        rx_store(&y->next, n);

        if (CAS(&TOP.node, &n, y)) {
            break;
        }
    }
}

int pop() {
    Node *y, *z;

    while (true) {
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
	int r;

	push(42);
    r = pop();

    __VERIFIER_assert(r != EMPTY);

	return NULL;
}

void *worker_2(void *unused)
{
	int r;

	push(41);
    r = pop();

    __VERIFIER_assert(r != EMPTY);

	return NULL;
}

int main()
{
  pthread_t t1, t2;

  init();

  if (pthread_create(&t1, NULL, worker_1, NULL))
	abort();
  if (pthread_create(&t2, NULL, worker_2, NULL))
	abort();

  if (pthread_join(t1, NULL))
	abort();
  if (pthread_join(t2, NULL))
	abort();

  int r = pop();
  __VERIFIER_assert(r == EMPTY);



  return 0;
}