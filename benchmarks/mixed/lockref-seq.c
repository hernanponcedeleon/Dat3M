#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>
#include "lockref.h"

#ifndef NTHREADS
#define NTHREADS 2
#endif

struct lockref my_lockref;

void *get(void *unused) {

    lockref_get(&my_lockref);

    return NULL;
}

void *ret(void *unused) {

    lockref_put_return(&my_lockref);

    return NULL;
}

int main() {

    pthread_t g[NTHREADS];
    pthread_t r[NTHREADS];

    atomic_store(&my_lockref.lock_count, 0);

    for (int i = 0; i < NTHREADS; i++)
        pthread_create(&g[i], 0, get, (void *)(size_t)i);
    for (int i = 0; i < NTHREADS; i++)
        pthread_join(g[i], 0);
    assert(my_lockref.count == NTHREADS); // Correct since all get first

    for (int i = 0; i < NTHREADS; i++)
        pthread_create(&r[i], 0, ret, (void *)(size_t)i);
    for (int i = 0; i < NTHREADS; i++)
        pthread_join(r[i], 0);
    assert(my_lockref.count == 0); // Correct since every decrement has a matching increment

    return 0;
}