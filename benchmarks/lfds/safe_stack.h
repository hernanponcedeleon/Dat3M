#include <stdatomic.h>

#ifndef SIZE
#define SIZE 3
#endif

typedef struct {
    volatile int value;
    atomic_int next;
} SafeStackItem;

atomic_int head;
atomic_int count;
SafeStackItem array[SIZE];

void init() {
    
    // Creates stack of fixed size
    atomic_init(&count, SIZE);
    atomic_init(&head, 0);

    for (int i = 0; i < SIZE - 1; i++)
        atomic_init(&array[i].next, i+1);

    atomic_init(&array[SIZE - 1].next, -1);
}

int pop() {
    while (atomic_load_explicit(&count, memory_order_acquire) > 1) {
        int head1 = atomic_load_explicit(&head, memory_order_acquire);
        int next1 = atomic_exchange_explicit(&array[head1].next, -1, memory_order_seq_cst);

        if (next1 >= 0) {
            int head2 = head1;
            if (atomic_compare_exchange_strong_explicit(&head, &head2, next1, memory_order_seq_cst, memory_order_seq_cst)) {
                atomic_fetch_sub_explicit(&count, 1, memory_order_seq_cst);
                return head1;
            } else {
                // Why Xchg instead of a simple store?
                atomic_exchange_explicit(&array[head1].next, next1, memory_order_seq_cst);
            }
        }
    }
    return -1;
}

void push(int index) {
    int head1 = atomic_load_explicit(&head, memory_order_acquire);
    do {
        atomic_store_explicit(&array[index].next, head1, memory_order_release);
    } while (atomic_compare_exchange_strong_explicit(&head, &head1, index, memory_order_seq_cst, memory_order_seq_cst) == 0);
    atomic_fetch_add_explicit(&count, 1, memory_order_seq_cst);
}