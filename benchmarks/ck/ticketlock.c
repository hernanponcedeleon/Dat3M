#include <assert.h>
#include <ck_spinlock.h>  // Include the ticket lock header
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

#define NTHREADS 3  // Number of threads

int x = 0, y = 0;
ck_spinlock_ticket_t *ticket_lock;

void *run(void *arg) {
    int tid = (int)(long)arg;


    // Acquire the ticket lock
    ck_spinlock_ticket_lock(ticket_lock);

    // Critical section
    x++;
    y++;

    // Release the ticket lock
    ck_spinlock_ticket_unlock(ticket_lock);

    return NULL;
}

int main() {
    pthread_t threads[NTHREADS];
    int i;

    // Initialize the ticket lock
    ticket_lock = (ck_spinlock_ticket_t *)malloc(sizeof(ck_spinlock_ticket_t));
    ck_spinlock_ticket_init(ticket_lock);

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

    // Clean up
    free(ticket_lock);

    return 0;
}
