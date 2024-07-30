#include <stdlib.h>
#include <pthread.h>
#include <assert.h>
#include <stdatomic.h>

atomic_int x = 0;

void *thread_1(void *unused)
{
    while (x != 1);
    return 0;
}

int main()
{
    pthread_t t1, t2;
#ifndef FAIL
    x = 1;
    pthread_create(&t1, NULL, thread_1, NULL);
#else
    pthread_create(&t1, NULL, thread_1, NULL);
    // Under totally unfair scheduling, we can stop here, never signaling T1
    x = 1;
#endif
    return 0;
}
