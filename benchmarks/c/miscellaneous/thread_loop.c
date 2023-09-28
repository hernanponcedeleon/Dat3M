#include <pthread.h>
#include <stdatomic.h>
#include <assert.h>
#include <dat3m.h>

/*
    The test shows thread creation inside loops
    Expected result: FAIL
*/

#ifndef N
#define N 5
#endif

atomic_int data;

void *worker(void *arg)
{
   atomic_fetch_add(&data, 1);
   return NULL;
}

int main()
{
    pthread_t t[N];
    int bound = __VERIFIER_nondet_int();
    __VERIFIER_assume(0 <= bound && bound < N);

    __VERIFIER_loop_bound(N + 1);
    for (int i = 0; i < bound; i++) {
        pthread_create(&t[i], NULL, worker, NULL);
    }

    assert(data != N - 1);
}
