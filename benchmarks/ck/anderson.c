#include <assert.h>
#include <ck_spinlock.h>
#include <pthread.h>
#include <stdlib.h>

#ifndef NTHREADS
    #define NTHREADS 3
#endif

int x = 0, y = 0;
ck_spinlock_anderson_t lock;
ck_spinlock_anderson_thread_t *slots;

void *run(void *arg) {
    ck_spinlock_anderson_thread_t *my_slot;
    ck_spinlock_anderson_lock(&lock, &my_slot);

    x++;
    y++;

    ck_spinlock_anderson_unlock(&lock, my_slot);
    return NULL;
}

int main() {
    pthread_t threads[NTHREADS];
    int i;

    slots = (ck_spinlock_anderson_thread_t *)malloc(sizeof(ck_spinlock_anderson_thread_t) * NTHREADS);
    if (slots == NULL) {
        exit(EXIT_FAILURE);
    }

    ck_spinlock_anderson_init(&lock, slots, NTHREADS);

    for (i = 0; i < NTHREADS; i++) {
        if (pthread_create(&threads[i], NULL, run, NULL) != 0) {
            exit(EXIT_FAILURE);
        }
    }

    for (i = 0; i < NTHREADS; i++) {
        if (pthread_join(threads[i], NULL) != 0) {
            exit(EXIT_FAILURE);
        }
    }

    assert(x == NTHREADS && y == NTHREADS);

    free(slots);

    return 0;
}
