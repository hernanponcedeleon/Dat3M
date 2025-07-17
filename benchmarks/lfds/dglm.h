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

#define RETIRE_THRESHOLD 10
Node* retired[RETIRE_THRESHOLD];
_Atomic int retired_count = 0;


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

	while (1) {
		head = atomic_load_explicit(&Head, __ATOMIC_ACQUIRE);
        assert(head != NULL);
		next = atomic_load_explicit(&head->next, __ATOMIC_ACQUIRE);

		if (head == atomic_load_explicit(&Head, __ATOMIC_ACQUIRE)) {
			if (next == NULL) {
				result = EMPTY;
				break;

			} else {
                result = next->val;
                if (CAS(&Head, &head, next)) {
                    tail = atomic_load_explicit(&Tail, __ATOMIC_ACQUIRE);
                    assert(tail != NULL);
                    if (head == tail) {
                        CAS(&Tail, &tail, next);
                    }
                    // free(head);
					retired[atomic_fetch_add(&retired_count, 1)] = head;
                    break;
                }
			}
		}
	}

	return result;
}

void free_all_retired() {
    for (int i = 0; i < retired_count; ++i) {
        free(retired[i]);
    }
    retired_count = 0;
}
