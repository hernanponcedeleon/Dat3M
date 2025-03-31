#include <pthread.h>
#include <stdatomic.h>

atomic_int x;

void* thread(void* arg) {
    while (atomic_load(&x) == 0);
    return NULL;
}

int main() {
    pthread_t t;
    atomic_init(&x, 0);

    pthread_create(&t, NULL, thread, NULL);
    pthread_join(t, NULL);

    atomic_store(&x, 1);

    return 0;
}
