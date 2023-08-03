#include <stdatomic.h>
#include <assert.h>
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

	while (1) {
		tail = atomic_load_explicit(&Tail, __ATOMIC_ACQUIRE);
		assert(tail != NULL);
		next = atomic_load_explicit(&tail->next, __ATOMIC_ACQUIRE);

		if (tail == atomic_load_explicit(&Tail, __ATOMIC_ACQUIRE)) {
			if (next != NULL) {
				CAS(&Tail, &tail, next);
			} else {
				if (CAS(&tail->next, &next, node)) {
				    CAS(&Tail, &tail, node);
					break;
				}
			}
		}
	}
}

int dequeue() {
	Node *head, *next, *tail;
	int result;

	while (1) {
		head = atomic_load_explicit(&Head, __ATOMIC_ACQUIRE);
		assert(head != NULL);
		tail = atomic_load_explicit(&Tail, __ATOMIC_ACQUIRE);
		assert(tail != NULL);
		next = atomic_load_explicit(&head->next, __ATOMIC_ACQUIRE);

		if (head == atomic_load_explicit(&Head, __ATOMIC_ACQUIRE)) {
			if (next == NULL) {
				result = EMPTY;
				break;
			} else {
				if (head == tail) {
					CAS(&Tail, &tail, next);
				} else {
					result = next->val;
					if (CAS(&Head, &head, next)) {
                        //retire(head);
                        break;
                    }
				}
			}
		}
	}

	return result;
}