#include <assert.h>
#include <ck_spinlock.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

#ifndef NTHREADS
#define NTHREADS 2
#endif

ck_spinlock_mcs_t lock = NULL;
ck_spinlock_mcs_t nodes;

int x = 0, y = 0;

void *run(void *arg)
{

    intptr_t tid = ((intptr_t)arg);

    ck_spinlock_mcs_t thread_node = &nodes[tid];

    ck_spinlock_mcs_lock(&lock, thread_node);

    x++;
    y++;

    ck_spinlock_mcs_unlock(&lock, thread_node);

    return NULL;
}

int main()
{
    pthread_t threads[NTHREADS];
    int tids[NTHREADS];
    int i;

    nodes = (ck_spinlock_mcs_t)malloc(NTHREADS * sizeof(ck_spinlock_mcs_t));
    if (nodes == NULL)
    {
        exit(EXIT_FAILURE);
    }

    lock = NULL;

    for (i = 0; i < NTHREADS; i++)
    {
        if (pthread_create(&threads[i], NULL, run, (void *)(size_t)i) != 0)
        {
            free(nodes);
            exit(EXIT_FAILURE);
        }
    }

    for (i = 0; i < NTHREADS; i++)
    {
        if (pthread_join(threads[i], NULL) != 0)
        {
            free(nodes);
            exit(EXIT_FAILURE);
        }
    }

    assert(x == NTHREADS && y == NTHREADS);

    free(nodes);

    return 0;
}
