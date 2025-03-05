#include <assert.h>
#include <ck_spinlock.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

#define NTHREADS 3  // Number of threads

int x = 0, y = 0;
ck_spinlock_clh_t *lock;
ck_spinlock_clh_t *nodes;

void *run(void *arg) {
    int tid = (int)(long)arg;

    // Each thread uses a separate node for the CLH lock
    ck_spinlock_clh_t *thread_node = &nodes[tid];

    ck_spinlock_clh_lock(&lock, thread_node);

    x++;
    y++;

    ck_spinlock_clh_unlock(&thread_node);

    return NULL;
}

int main() {
    pthread_t threads[NTHREADS];
    int i;

    // Initialize lock
    ck_spinlock_clh_t unowned;
    ck_spinlock_clh_init(&lock, &unowned);

    // Allocate memory for the nodes (one per thread)
    nodes = (ck_spinlock_clh_t *)malloc(NTHREADS * sizeof(ck_spinlock_clh_t));
    for (i = 0; i < NTHREADS; i++) {
        ck_spinlock_clh_t unowned_node;
        ck_spinlock_clh_init(&nodes[i], &unowned_node);  // Initialize each thread's node
    }

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

    // Verify the values of x and y
    assert(x == NTHREADS && y == NTHREADS);

    // Clean up
    free(nodes);

    return 0;
}
