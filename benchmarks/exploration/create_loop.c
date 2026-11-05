#include <pthread.h>
#include <stdatomic.h>
#include <assert.h>
#include <stdint.h>

// Threads are created and joined in loops. The loops are not unrolled: each execution of
// pthread_create spawns a new thread instance. Each thread returns its argument.

#ifndef N
#define N 3
#endif

atomic_int counter;

void *worker(void *arg) {
    atomic_fetch_add_explicit(&counter, 1, memory_order_relaxed);
    return arg;
}

int main() {
    pthread_t t[N];
    for (intptr_t i = 0; i < N; i++) {
        pthread_create(&t[i], NULL, worker, (void *) i);
    }
    intptr_t sum = 0;
    for (int i = 0; i < N; i++) {
        void *ret;
        pthread_join(t[i], &ret);
        sum += (intptr_t) ret;
    }
    assert(sum == N * (N - 1) / 2);
    assert(atomic_load_explicit(&counter, memory_order_relaxed) == N);
    return 0;
}
