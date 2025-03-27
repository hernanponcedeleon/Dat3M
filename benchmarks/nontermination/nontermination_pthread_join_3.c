#include <pthread.h>
#include <stdatomic.h>
#include <assert.h>

atomic_int x, y;

void* thread0(void* arg) {
    atomic_store_explicit(&y, 1, memory_order_release);
    return NULL;
}

void* thread1(void* arg) {
    while (atomic_load_explicit(&x, memory_order_acquire) == 0);
    atomic_store_explicit(&y, 2, memory_order_release);
    return NULL;
}

int main() {
    pthread_t t1, t2;
    atomic_init(&x, 0);
    atomic_init(&y, 0);

    pthread_create(&t1, NULL, thread0, NULL);
    pthread_create(&t2, NULL, thread1, NULL);

    atomic_store_explicit(&x, 1, memory_order_release);

    pthread_join(t1, NULL);
    pthread_join(t2, NULL);

    assert(atomic_load(&y) == 1 || atomic_load(&y) == 2);

    return 0;
}
