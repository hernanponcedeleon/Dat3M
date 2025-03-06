#include <assert.h>
#include <ck_spinlock.h>
#include <pthread.h>
#include <stdlib.h>

#ifndef NTHREADS
#define NTHREADS 3
#endif

int x = 0, y = 0;
ck_spinlock_clh_t *lock;
ck_spinlock_clh_t *nodes;

void *run(void *arg)
{
    intptr_t tid = ((intptr_t) arg);

    ck_spinlock_clh_t *thread_node = &nodes[tid];

    ck_spinlock_clh_lock(&lock, thread_node);

    x++;
    y++;

    ck_spinlock_clh_unlock(&thread_node);

    return NULL;
}

int main()
{
    pthread_t threads[NTHREADS];
    int tids[NTHREADS];
    int i;

    ck_spinlock_clh_t unowned;
    ck_spinlock_clh_init(&lock, &unowned);

    nodes = (ck_spinlock_clh_t *)malloc(NTHREADS * sizeof(ck_spinlock_clh_t));
    for (i = 0; i < NTHREADS; i++)
    {
        ck_spinlock_clh_t unowned_node;
        ck_spinlock_clh_init(&nodes[i], &unowned_node);
    }

    for (i = 0; i < NTHREADS; i++)
    {
        if (pthread_create(&threads[i], NULL, run, (void *)(size_t) i) != 0)
        {
            exit(EXIT_FAILURE);
        }
    }

    for (i = 0; i < NTHREADS; i++)
    {
        if (pthread_join(threads[i], NULL) != 0)
        {
            exit(EXIT_FAILURE);
        }
    }

    assert(x == NTHREADS && y == NTHREADS);

    free(nodes);

    return 0;
}
