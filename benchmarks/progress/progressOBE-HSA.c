#include <stdlib.h>
#include <pthread.h>
#include <assert.h>
#include <stdatomic.h>

// Required progress: HSA or OBE (stronger than unfair)

atomic_int x = 0;

void *thread_1(void *unused)
{
    while (x != 0);
    return 0;
}

int main()
{
    pthread_t t1, t2;
    pthread_create(&t1, NULL, thread_1, NULL);
    x = 1;
    // Under totally unfair scheduling, we can stop here so that T1 spins forever
    x = 0;
    return 0;
}
