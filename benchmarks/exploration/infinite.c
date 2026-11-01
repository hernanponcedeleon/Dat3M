#include <pthread.h>
#include <stdatomic.h>
#include <assert.h>

// A thread runs an infinite loop with side effects (so it is not detected as a spin loop).
// The exploration does not terminate unless a bound on the events per thread is given.

atomic_int x;
atomic_int flag;

void *writer(void *arg) {
    // Infinite loop with side effects: never terminates.
    while (1) {
        atomic_fetch_add_explicit(&x, 1, memory_order_relaxed);
    }
    return NULL;
}

int main() {
    pthread_t t;
    pthread_create(&t, NULL, writer, NULL);
    int r = atomic_load_explicit(&x, memory_order_relaxed);
    assert(r < 3);
    return 0;
}
