#include <assert.h>
#include <ck_spinlock.h>
#include <dat3m.h>
#include <pthread.h>
#include <stdbool.h>
#include <stdlib.h>

#ifndef NTHREADS
#define NTHREADS 2
#endif

int x = 0, y = 0;
ck_spinlock_dec_t lock;
ck_spinlock_dec_t *nodes;

void *run(void *arg)
{
    intptr_t tid = ((intptr_t)arg);

    if (tid == NTHREADS - 1)
    {
        bool acquired = ck_spinlock_dec_trylock(&lock);
        __VERIFIER_assume(acquired);
    }
    else
    {
        ck_spinlock_dec_lock(&lock);
    }
    x++;
    y++;
    ck_spinlock_dec_unlock(&lock);

    return NULL;
}

int main()
{
    pthread_t threads[NTHREADS];
    int i;

    ck_spinlock_dec_init(&lock);

    for (i = 0; i < NTHREADS; i++)
    {
        if (pthread_create(&threads[i], NULL, run, (void *)(size_t)i) != 0)
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

    return 0;
}
