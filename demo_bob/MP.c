#include <pthread.h>
#include <assert.h>
#include <stdatomic.h>

volatile int message = 0;
volatile int signal = 0;

void *producer(void *arg) {
    message = 42;
    // atomic_thread_fence(memory_order_release);
    signal = 1;
    return NULL;
}

void *consumer(void *arg) {
    while (signal != 1);
    // atomic_thread_fence(memory_order_acquire);
    assert (message == 42);
    return NULL;
}

int main() {
    pthread_t t1, t2;
    pthread_create(&t1, NULL, producer, NULL);
    pthread_create(&t2, NULL, consumer, NULL);
}