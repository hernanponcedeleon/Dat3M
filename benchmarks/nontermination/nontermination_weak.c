#include <pthread.h>
#include <stdatomic.h>

/*
    Test case: Repeated message-passing until success
    Expected result: FAIL under all memory models that fail MP.
*/

volatile int x = 0;
atomic_int signal = 0;
atomic_int success = 0;
atomic_int sendAgain = 0;

void *thread(void *unused)
{
    while(1) {
        x = 1;
        atomic_store_explicit(&signal, 1, memory_order_relaxed);
        // Wait for acknowledgement
        while (!sendAgain && !success) { }
        if (sendAgain) {
            // Reset message, then try again
            x = 0;
            sendAgain = 0;
        }
        if (success) break;
    }
    return 0;
}

void *thread2(void *unused) {
    while (atomic_load_explicit(&signal, memory_order_relaxed) == 1 && x == 0) {
        // Message was wrong, ask for a new message
        signal = 0;
        sendAgain = 1;
    }
    success = 1;
    return 0;
}

int main()
{
    pthread_t t1, t2;
    pthread_create(&t1, NULL, thread, NULL);
    pthread_create(&t2, NULL, thread2, NULL);

    return 0;
}