#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>

extern void abort(void);

#define CAS(ptr, expected, desired) (atomic_compare_exchange_strong_explicit(ptr, expected, desired, __ATOMIC_ACQ_REL, __ATOMIC_SEQ_CST))

/*
extern void retire(Node* ptr);
extern void enterQ();
extern void leaveQ();
*/

typedef struct Node {
	int val;
	_Atomic(struct Node*) next;
} Node;

_Atomic(Node *) Tail;
_Atomic(Node *) Head;

void reach_error() { assert(0); }

void __VERIFIER_assert(int expression) { if (!expression) { ERROR: {reach_error();abort();}}; return; }

void init() {
	Head = malloc(sizeof (Node));
	Head->next = NULL;
	Tail = Head;
}

void enqueue(int value) {
	Node *tail, *next, *node;

	//leaveQ();

	//node = malloc;
    node = malloc(sizeof (Node));
	node->val = value;
	node->next = NULL;

	while (true) {
		tail = Tail;
		next = tail->next;

		if (tail == Tail) {
			if (next != NULL) {
				//CAS(&Tail, &tail, next); 
				CAS(&Tail, tail, next);

			} else {
				//if (CAS(&tail->next, &next, node)) {
				if (CAS(&tail->next, next, node)) {
					//CAS(&Tail, &tail, node); 
				    CAS(&Tail, tail, node);
					break;
				}
			}
		}
	}

	//enterQ();
}

int dequeue() {
	Node *head, *next, *tail;
	int result;

	//leaveQ();

	while (true) {
		head = Head;
		tail = Tail;
		next = head->next;

		if (head == Head) {
			if (next == NULL) {
				result = -1;
				break;

			} else {
				if (head == tail) {
					// CAS(&Tail, &tail, next); 
					CAS(&Tail, tail, next);

				} else {
					result = next->val;
                    //if (CAS(&Head, &head, next)) {  
					if (CAS(&Head, head, next)) {
                        //retire(head);
                        break;
                    }
				}
			}
		}
	}

	//enterQ();
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

	enqueue(42);
    r = dequeue();

	__VERIFIER_assert(r == 42);

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

  int empty = dequeue();
  __VERIFIER_assert(empty < 0);



  return 0;
}