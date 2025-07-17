#include "ms.h"
#include <pthread.h>

#ifndef NTHREADS
#define NTHREADS 3
#endif

void *worker(void *arg)
{

    intptr_t index = ((intptr_t) arg);

	enqueue(index);
    int r = dequeue();

	assert(r != EMPTY);

	return NULL;
}

int main()
{
    pthread_t t[NTHREADS];

    init();

    for (int i = 0; i < NTHREADS; i++)
        pthread_create(&t[i], 0, worker, (void *)(size_t)i);

    for (int i = 0; i < NTHREADS; i++)
        pthread_join(t[i], 0);

    int r = dequeue();
    assert(r == EMPTY);

    free_all_retired();

    return 0;
}