#include <stdlib.h>
#include <pthread.h>
#include <assert.h>
#include <stdatomic.h>

atomic_int x = 0;

void *thread_1(void *unused)
{
    while (x != 0);
    return 0;
}

void *thread_2(void *unused)
{
    x = 1;
    // HSA may stop here causing a liveness issue (OBE cannot do this)
    x = 0;
}

int main()
{
    pthread_t t1, t2;
    pthread_create(&t1, NULL, thread_1, NULL);
    pthread_create(&t2, NULL, thread_2, NULL);
    return 0;
}
