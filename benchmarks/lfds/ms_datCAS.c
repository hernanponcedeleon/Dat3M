#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>

extern _Bool __DAT3M_CAS();

extern void abort(void);

#define CAS(ptr, expected, desired) (__DAT3M_CAS(ptr, expected, desired, __ATOMIC_ACQ_REL))
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
	atomic_init(&node->next, NULL);
	atomic_init(&Head, node); 
	atomic_init(&Tail, node);
}

void enqueue(int value) {
	Node *tail, *next, *node;

    node = malloc(sizeof (Node));
	node->val = value;
	atomic_init(&node->next, NULL);

	while (true) {
		tail = load(&Tail);
		__VERIFIER_assert(tail != NULL);
		next = load(&tail->next);

		if (tail == load(&Tail)) {
			if (next != NULL) {
				CAS(&Tail, tail, next);

			} else {
				if (CAS(&tail->next, next, node)) {
				    CAS(&Tail, tail, node);
					break;
				}
			}
		}
	}
}

int dequeue() {
	Node *head, *next, *tail;
	int result;

	while (true) {
		head = load(&Head);
		__VERIFIER_assert(head != NULL);
		tail = load(&Tail);
		__VERIFIER_assert(tail != NULL);
		next = load(&head->next);

		if (head == load(&Head)) {
			if (next == NULL) {
				result = EMPTY;
				break;

			} else {
				if (head == tail) {
					CAS(&Tail, tail, next);

				} else {
					result = next->val;
					if (CAS(&Head, head, next)) {
                        //retire(head);
                        break;
                    }
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

	__VERIFIER_assert(r != EMPTY);

	return NULL;
}

void *worker_2(void *unused)
{
	int r;

	enqueue(41);
    r = dequeue();

	__VERIFIER_assert(r != EMPTY);

	return NULL;
}


int main()
{
  pthread_t t1, t2, t3, t4;

  init();

  if (pthread_create(&t1, NULL, worker_1, NULL))
	abort();
  if (pthread_create(&t2, NULL, worker_2, NULL))
	abort();
  if (pthread_create(&t3, NULL, worker_1, NULL))
	abort();
  if (pthread_create(&t4, NULL, worker_2, NULL))
	abort();

  if (pthread_join(t1, NULL))
	abort();
  if (pthread_join(t2, NULL))
	abort();
  if (pthread_join(t3, NULL))
	abort();
  if (pthread_join(t4, NULL))
	abort();

  int r = dequeue();
  __VERIFIER_assert(r == EMPTY);



  return 0;
}