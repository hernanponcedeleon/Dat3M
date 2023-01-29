#include <pthread.h>
#include "cna.h"
#include <assert.h>
 
#ifndef NTHREADS
#define NTHREADS 3
#endif

__thread intptr_t tindex;

cna_lock_t lock;
cna_node_t node[NTHREADS];
int shared = 0;
int sum = 0;

void *thread_n(void *arg)
{
    tindex = ((intptr_t) arg);
    cna_lock(&lock, &node[tindex]);
    shared = tindex;
    int r = shared;
    assert(r == tindex);
    sum++;
    cna_unlock(&lock, &node[tindex]);
    return NULL;
}
 
int main()
{
    pthread_t t[NTHREADS];
 
    for (int i = 0; i < NTHREADS; i++)
        pthread_create(&t[i], 0, thread_n, (void *)i);

    for (int i = 0; i < NTHREADS; i++)
        pthread_join(t[i], 0);

    assert(sum == NTHREADS);
 
    return 0;
}

