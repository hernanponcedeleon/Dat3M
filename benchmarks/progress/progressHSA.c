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

void *thread_2(void *unused)
{
    x = 1; // May not get scheduled under HSA
}

int main()
{
    pthread_t t1, t2;
#ifndef FAIL
    pthread_create(&t2, NULL, thread_2, NULL);
    pthread_create(&t1, NULL, thread_1, NULL);
#else
    pthread_create(&t1, NULL, thread_1, NULL);
    pthread_create(&t2, NULL, thread_2, NULL);
#endif
    return 0;
}
