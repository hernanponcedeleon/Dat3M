#include <pthread.h>
#include <stdatomic.h>

/*
    Test case: Repeated message-passing until success
    Expected result: FAIL under all memory models that fail MP.
*/

volatile int x = 0;
volatile int signal = 0;
volatile int success = 0;

void *thread(void *unused)
{
    while(!success) {
        x = 1;
        signal = 1;
    }
}

void *thread2(void *unused) {
    while (signal == 1 && x == 0) {
        // Message was wrong, reset and wait for new one.
        x = 0;
        signal = 0;
    }
    success = 1;
}

int main()
{
    pthread_t t1, t2;
    pthread_create(&t1, NULL, thread, NULL);
    pthread_create(&t2, NULL, thread2, NULL);

    return 0;
}