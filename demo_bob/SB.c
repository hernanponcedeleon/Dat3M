#include <pthread.h>
#include <assert.h>
#include <stdatomic.h>

volatile int x = 0;
volatile int y = 0;
volatile int r1 = 0;
volatile int r2 = 0;

void *thread1(void *arg) {
    x = 1;
    r1 = y;
    return NULL;
}

void *thread2(void *arg) {
    y = 1;
    r2 = x;
    return NULL;
}

int main() {
    pthread_t t1, t2;
    pthread_create(&t1, NULL, thread1, NULL);
    pthread_create(&t2, NULL, thread2, NULL);
    pthread_join(t1, NULL);
    pthread_join(t2, NULL);
    
    assert(r1 != 0 || r2 != 0);
}