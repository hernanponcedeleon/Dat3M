#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <pthread.h>
#include <stdatomic.h>
#include <assert.h>

typedef struct {
    int value;
    atomic_int next;
} SafeStackItem;

atomic_int head;
atomic_int count;
SafeStackItem array[3];

    void init()
    {
        // Creates stack of fixed size 3
        atomic_init(&count, 3);
        atomic_init(&head, 0);

        atomic_init(&array[0].next, 1);
        atomic_init(&array[1].next, 2);
        atomic_init(&array[2].next, -1);

        /*for (int i = 0; i < pushCount - 1; i++)
            array[i].Next.store(i + 1, std::memory_order_relaxed);
        array[pushCount - 1].Next.store(-1, std::memory_order_relaxed);*/
    }

    int pop() 
    {
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

        /*
        ======== Original C++ code ========

        while (count.load(std::memory_order_acquire) > 1)
        {
            int head1 = head.load(std::memory_order_acquire);
            int next1 = array[head1].Next.exchange(-1, std::memory_order_seq_cst);

            if (next1 >= 0)
            {
                int head2 = head1;
                if (head.compare_exchange_strong(head2, next1, std::memory_order_seq_cst))
                {
                    count.fetch_sub(1, std::memory_order_seq_cst);
                    return head1;
                }
                else
                {
                    array[head1].Next.exchange(next1, std::memory_order_seq_cst);
                }
            }
            else
            {
                pthread_yield();
            }
        }

        return -1;*/
    }

    void push(int index) 
    {
        int head1 = atomic_load_explicit(&head, memory_order_acquire);
        do {
            atomic_store_explicit(&array[index].next, head1, memory_order_release);
        } while (atomic_compare_exchange_strong_explicit(&head, &head1, index, memory_order_seq_cst, memory_order_seq_cst) == 0);
        atomic_fetch_add_explicit(&count, 1, memory_order_seq_cst);


        /*
        ======== Original C++ code ========

        int head1 = head.load(std::memory_order_acquire);
        do
        {
            array[index].Next.store(head1, std::memory_order_release);
            
        } while (!head.compare_exchange_strong(head1, index, std::memory_order_seq_cst));
        count.fetch_add(1, std::memory_order_seq_cst); */
    }

    void *thread(void *arg)
    {
        intptr_t idx = ((intptr_t) arg);

        int elem;
        // Unrolling of the original C++ Code
        while (1) {
            elem = pop();
            if (elem >= 0) {
                break;
            }
    
        }
        array[elem].value = idx;
        assert (array[elem].value == idx);
        push(elem);

        while (1) {
            elem = pop();
            if (elem >= 0)
                 break;
        }
        array[elem].value = idx;
        assert (array[elem].value == idx);
        push(elem);

        return NULL;

/*
        ======== Original C++ code ========
        for (size_t i = 0; i != 2; i += 1) {
            int elem;
            while (1) {
                elem = stack.Pop();
                if (elem >= 0)
                    break;
                //pthread_yield();
            }

            stack.array[elem].VAR(Value) = 1;
            stack.Push(elem);
        }
*/
    }

int main()
{
    pthread_t t0, t1, t2;

    init();
    
    pthread_create(&t0, NULL, thread, (void *) 0);
    pthread_create(&t1, NULL, thread, (void *) 1);
    pthread_create(&t2, NULL, thread, (void *) 2);

    return 0;
}
