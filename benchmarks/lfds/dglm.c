#include "dglm.h"
#include <pthread.h>

#ifndef NTHREADS
#define NTHREADS 3
#endif

int data[NTHREADS];

void *worker(void *arg)
{

    intptr_t index = ((intptr_t) arg);

	enqueue(index);
    int r = dequeue();

	assert(r != EMPTY);
	data[r] = 1;

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
    free(Head);

    free_all_retired();

    for (int i = 0; i < NTHREADS; i++)
        assert(data[i] == 1);

    return 0;
}
