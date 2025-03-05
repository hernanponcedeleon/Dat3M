#include <assert.h>
#include <ck_spinlock.h>  // Include the Anderson lock header
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

#define NTHREADS 3  // Number of threads

int x = 0, y = 0;
ck_spinlock_anderson_t lock;  // Declare the Anderson lock
ck_spinlock_anderson_thread_t *slots;

void *run(void *arg) {
    int tid = (int)(long)arg;
    ck_spinlock_anderson_thread_t *my_slot;

    // Acquire the Anderson lock
    ck_spinlock_anderson_lock(&lock, &my_slot);

    // Critical section
    x++;
    y++;

    // Release the Anderson lock
    ck_spinlock_anderson_unlock(&lock, my_slot);

    return NULL;
}

int main() {
    pthread_t threads[NTHREADS];
    int i;

    // Allocate memory for the slots array
    slots = (ck_spinlock_anderson_thread_t *)malloc(
        sizeof(ck_spinlock_anderson_thread_t) * NTHREADS);
    if (slots == NULL) {
        exit(EXIT_FAILURE);
    }

    // Initialize the Anderson lock with the slots
    ck_spinlock_anderson_init(&lock, slots, NTHREADS);

    // Create threads
    for (i = 0; i < NTHREADS; i++) {
        if (pthread_create(&threads[i], NULL, run, (void *)(long)i) != 0) {
            exit(EXIT_FAILURE);
        }
    }

    // Join threads
    for (i = 0; i < NTHREADS; i++) {
        if (pthread_join(threads[i], NULL) != 0) {
            exit(EXIT_FAILURE);
        }
    }

    // Verify the values of x and y after all threads have finished
    assert(x == NTHREADS && y == NTHREADS);

    // Free the allocated memory for slots
    free(slots);

    return 0;
}
