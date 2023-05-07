#include <stdlib.h>
#include <pthread.h>
#include <assert.h>
#include <stdatomic.h>

int sum;
pthread_mutex_t m;

#ifndef NTHREADS
#define NTHREADS 3
#endif

void *run(void *unused)
{
    pthread_mutex_lock(&m);
    sum++;
    pthread_mutex_unlock(&m);
    return NULL;
}

int main()
{
    pthread_t t[NTHREADS];

    pthread_mutex_init(&m, NULL);

    for (int i = 0; i < NTHREADS; i++)
        pthread_create(&t[i], 0, run, (void *)i);

    for (int i = 0; i < NTHREADS; i++)
        pthread_join(t[i], 0);

    assert(sum == NTHREADS);

    return 0;
}
