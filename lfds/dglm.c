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

_Atomic(Node *) Tail;
_Atomic(Node *) Head;


void init() {
	Node* node = malloc(sizeof (Node));
	rx_store(&node->next, NULL);
	atomic_init(&Head, node); 
	atomic_init(&Head, node);
}

void enqueue(int value) {
	Node *tail, *next, *node;
    bool b1;

    node = malloc(sizeof (Node));
	node->val = value;
	atomic_init(&node->next, NULL);

	while (true) {
		tail = load(&Tail);
		next = load(&tail->next);
        b1 = (tail == load(&Tail));

        if (b1) {
            if (next == NULL) {
				if (CAS(&tail->next, &next, node)) {
				    CAS(&Tail, &tail, node);
					break;
                }
            } else {
				CAS(&Tail, &tail, next);
            }
			
        }
	}
}

int dequeue() {
	Node *head, *next, *tail;
	int result;

	while (true) {
		head = load(&Head);
		next = rx_load(&head->next);

		if (head == load(&Head)) {
			if (next == NULL) {
				result = EMPTY;
				break;

			} else {
                result = next->val; //make atomic?
                if (CAS(&Head, &head, next)) {
                    tail = load(&Tail);
                    if (head == tail) {
                        CAS(&Tail, &tail, next);
                    }
                    break;
                }
			}
		}
	}

	return result;
}


// =========== Worker threads ==============

void *worker_1(void *unused)
{
	int r;

	enqueue(42);
    r = dequeue();

	__VERIFIER_assert(r == 42);

	return NULL;
}

void *worker_2(void *unused)
{
	int r;

	enqueue(41);
    r = dequeue();

	__VERIFIER_assert(r == 41);

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

  int r = dequeue();
  __VERIFIER_assert(r == EMPTY);



  return 0;
}