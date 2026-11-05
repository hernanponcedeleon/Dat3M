#include <pthread.h>
#include <assert.h>

// Threads created in a loop increment a counter non-atomically: an increment can be lost.

#ifndef N
#define N 3
#endif

int counter;

void *worker(void *arg) {
    counter = counter + 1;
    return NULL;
}

int main() {
    pthread_t t[N];
    for (int i = 0; i < N; i++) {
        pthread_create(&t[i], NULL, worker, NULL);
    }
    for (int i = 0; i < N; i++) {
        pthread_join(t[i], NULL);
    }
    assert(counter == N);
    return 0;
}
