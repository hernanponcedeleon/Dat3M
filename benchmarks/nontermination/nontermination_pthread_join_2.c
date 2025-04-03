#include <pthread.h>
#include <stdatomic.h>

atomic_int x;

void* thread0(void* arg) {
    while (atomic_load_explicit(&x, memory_order_acquire) == 0);
    return NULL;
}

void* thread1(void* arg) {
    atomic_store_explicit(&x, 1, memory_order_release);
    return NULL;
}

int main() {
    pthread_t t1, t2;
    atomic_init(&x, 0);

    pthread_create(&t1, NULL, thread0, NULL);
    pthread_create(&t2, NULL, thread1, NULL);

    pthread_join(t1, NULL);
    pthread_join(t2, NULL);

    return 0;
}
