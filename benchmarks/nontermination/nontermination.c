#include <pthread.h>

/*
    Test case: Oscillating memory value but the same value is constantly observed
    Expected result: FAIL under all memory models.
*/

volatile int x = 0;
volatile int y = 0;

void *thread(void *unused)
{
    while(y != 1) {
        x = 1;
        x = 2;
    }
}

void *thread2(void *unused) {
    while (x != 2) { }
    y = 1;
}

int main()
{
    pthread_t t1, t2;
    pthread_create(&t1, NULL, thread, NULL);
    pthread_create(&t2, NULL, thread2, NULL);

    return 0;
}