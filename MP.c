#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <pthread.h>
#include <stdatomic.h>
#include <assert.h>

extern void __VERIFIER_assume();

#define N 10

//int m[N];
int *m;
atomic_int flag;

void *producer(void *arg) {
    for (int i = 0; i < N; i++) {
        m[i] = i+1; // We want to avoid writing 0 since this is the initial value
    }
    
    atomic_thread_fence(memory_order_seq_cst);
    int r = 0;
    atomic_compare_exchange_strong_explicit(&flag, &r, 1,
                            memory_order_seq_cst,
                            memory_order_relaxed);
    //atomic_store_explicit(&flag, 1, memory_order_release);
}

void *consumer(void *arg) {
    int r = 1;
//    __VERIFIER_assume(atomic_compare_exchange_strong_explicit(&flag, &r, 2,
//                            memory_order_seq_cst,
//                            memory_order_relaxed));
    atomic_thread_fence(memory_order_seq_cst);
    while (atomic_load_explicit(&flag, memory_order_acquire) != 1) {
    }
    //__VERIFIER_assume(atomic_load_explicit(&flag, memory_order_acquire) ==  1);
    
    for (int i = 0; i < N; i++) {
        assert(m[i] == i+1);
    }
}

// variant
//
int main()
{
    pthread_t t0, t1;
    atomic_init(&flag, 0);
    m = malloc(sizeof(int) * N);
    
    pthread_create(&t0, NULL, producer, NULL);
    pthread_create(&t1, NULL, consumer, NULL);
    
    return 0;
}
