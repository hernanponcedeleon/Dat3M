#include <pthread.h>
#include <stdatomic.h>

atomic_int a, b;

void* thread0(void* arg) {
    while (atomic_load(&b) == 0);
    atomic_store(&a, 1);
    return NULL;
}

void* thread1(void* arg) {
    while (atomic_load(&a) == 0);
    atomic_store(&b, 1);
    return NULL;
}

int main() {
    pthread_t t1, t2;
    atomic_init(&a, 0);
    atomic_init(&b, 0);

    pthread_create(&t1, NULL, thread0, NULL);
    pthread_create(&t2, NULL, thread1, NULL);

    pthread_join(t1, NULL);
    pthread_join(t2, NULL);

    return 0;
}
