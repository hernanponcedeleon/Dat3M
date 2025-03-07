#include <assert.h>
#include <ck_spinlock.h>
#include <dat3m.h>
#include <pthread.h>
#include <stdlib.h>

#ifndef NTHREADS
#define NTHREADS 3
#endif

// RISCV asm uses amo instructions for ck_spinlock_cas_trylock -> ck_pr_fas_uint
// In such a case we avoid trylock and simply use cas_lock

ck_spinlock_cas_t lock;
int x = 0, y = 0;

void *run(void *arg)
{
    
    intptr_t tid = ((intptr_t) arg);
#ifdef __riscv
    ck_spinlock_cas_lock(&lock);
#else
    if (tid == NTHREADS - 1)
    {
        bool acquired = ck_spinlock_cas_trylock(&lock);
        __VERIFIER_assume(acquired);
    }
    else
    {
        ck_spinlock_cas_lock(&lock);
    }
#endif
    x++;
    y++;
    ck_spinlock_cas_unlock(&lock);
    return NULL;
}

int main()
{
    pthread_t threads[NTHREADS];
    int i;
    ck_spinlock_cas_init(&lock);
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
        };
    }
    assert(x == NTHREADS && y == NTHREADS);
    return 0;
}
