#include <pthread.h>
#include <assert.h>
#include "p64_rwlock.c"

#define NTHREADS 3


void *run(void *arg) {
    p64_rwlock_acquire_wr(&lock);
    x++;
    y++;
    p64_rwlock_release_wr(&lock);
    return NULL;
}

int main() {
    pthread_t threads[NTHREADS];
    p64_rwlock_init(&lock);

    for (int i = 0; i < NTHREADS; i++) {
        if (pthread_create(&threads[i], NULL, run, (void *)(long)i) != 0) {
            exit(EXIT_FAILURE);
        }
    }

    for (int i = 0; i < NTHREADS; i++) {
        if (pthread_join(threads[i], NULL) != 0) {
            exit(EXIT_FAILURE);
        }
    }

    assert(x == NTHREADS && y == NTHREADS);
    return 0;
}
