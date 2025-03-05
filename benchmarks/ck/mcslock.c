#include <assert.h>
#include <ck_spinlock.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

#define NTHREADS 3  // Number of threads

// Global MCS lock and thread-specific nodes
ck_spinlock_mcs_t lock = NULL;
ck_spinlock_mcs_t nodes;

int x = 0, y = 0;

// Thread function
void *run(void *arg) {
    long tid = (long)arg;

    // Each thread uses its own node in the MCS lock
    ck_spinlock_mcs_t thread_node = &nodes[tid];

    // Acquire the MCS lock
    ck_spinlock_mcs_lock(&lock, thread_node);

    // Critical section
    x++;
    y++;

    // Release the MCS lock
    ck_spinlock_mcs_unlock(&lock, thread_node);

    return NULL;
}

int main() {
    pthread_t threads[NTHREADS];
    int i;

    // Allocate memory for the thread-specific nodes
    nodes = (ck_spinlock_mcs_t)malloc(NTHREADS * sizeof(ck_spinlock_mcs_t));
    if (nodes == NULL) {
        exit(EXIT_FAILURE);
    }

    // Initialize the global lock to NULL (empty queue)
    lock = NULL;

    // Create threads
    for (i = 0; i < NTHREADS; i++) {
        if (pthread_create(&threads[i], NULL, run, (void *)(long)i) != 0) {
            free(nodes);
            exit(EXIT_FAILURE);
        }
    }

    // Join threads
    for (i = 0; i < NTHREADS; i++) {
        if (pthread_join(threads[i], NULL) != 0) {
            free(nodes);
            exit(EXIT_FAILURE);
        }
    }

    // Verify the values of x and y
    assert(x == NTHREADS && y == NTHREADS);

    // Clean up
    free(nodes);

    return 0;
}
