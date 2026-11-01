#include <pthread.h>
#include <stdatomic.h>
#include <assert.h>

// Message passing with a spin loop. Side-effect-free loop iterations are blocked (spin-assume),
// so the exploration terminates without unrolling.

atomic_int flag;
int data;

void *producer(void *arg) {
    data = 42;
    atomic_store_explicit(&flag, 1, memory_order_release);
    return NULL;
}

int main() {
    pthread_t t;
    pthread_create(&t, NULL, producer, NULL);
    while (atomic_load_explicit(&flag, memory_order_acquire) == 0) { }
    assert(data == 42);
    pthread_join(t, NULL);
    return 0;
}
