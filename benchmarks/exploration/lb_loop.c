#include <pthread.h>
#include <stdatomic.h>
#include <assert.h>

// Load buffering inside loops: the outcome r0 == r1 == 1 requires a (po U rf)-cycle.
// It is allowed by hardware models like ARMv8 (and by the original C11 model),
// but forbidden by RC11. Finding it requires the "dependencies" exploration order.

atomic_int x;
atomic_int y;
int r0, r1;

void *thread0(void *arg) {
    for (int i = 0; i < 2; i++) {
        r0 = atomic_load_explicit(&x, memory_order_relaxed);
    }
    atomic_store_explicit(&y, 1, memory_order_relaxed);
    return NULL;
}

void *thread1(void *arg) {
    r1 = atomic_load_explicit(&y, memory_order_relaxed);
    atomic_store_explicit(&x, 1, memory_order_relaxed);
    return NULL;
}

int main() {
    pthread_t t0, t1;
    pthread_create(&t0, NULL, thread0, NULL);
    pthread_create(&t1, NULL, thread1, NULL);
    pthread_join(t0, NULL);
    pthread_join(t1, NULL);
    assert(!(r0 == 1 && r1 == 1));
    return 0;
}
