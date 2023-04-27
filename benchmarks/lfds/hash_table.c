#include "hash_table.h"
#include <pthread.h>
#include <assert.h>

#ifndef PAIRS
#define PAIRS 2
#endif

#define NTHREADS (2 * PAIRS)

atomic_int data[PAIRS];
int read_flag[PAIRS], read_data[PAIRS];

// The hash_table is resilient against memory reordering, but externally, the
// caller may still need to enforce memory ordering using fence instructions.
// For example, if you publicize the availability of some data to other threads
// by storing a flag in the collection (MP pattern), you must place release
// semantics on that store by issuing a release fence immediately beforehand.

void *thread_1(void *arg)
{
    intptr_t idx = ((intptr_t)arg);
    atomic_store_explicit(&data[idx], 1, memory_order_relaxed);
#ifndef FAIL
    atomic_thread_fence(memory_order_release);
#endif
    // Set flag. +1 because keys cannot be 0
    set(idx + 1, 1);
    return NULL;
}

void *thread_2(void *arg)
{
    intptr_t idx = ((intptr_t)arg);
    // Read flag. +1 because keys cannot be 0
    read_flag[idx] = get(idx + 1);
    atomic_thread_fence(memory_order_acquire);
    read_data[idx] = atomic_load_explicit(&data[idx], memory_order_relaxed);
    return NULL;
}

int main()
{
    pthread_t t[NTHREADS];

    init();

    for (int i = 0; i < PAIRS; i++)
        pthread_create(&t[i], 0, thread_1, (void *)i);

    for (int i = 0; i < PAIRS; i++)
        pthread_create(&t[PAIRS + i], 0, thread_2, (void *)i);

    for (int i = 0; i < NTHREADS; i++)
        pthread_join(t[i], 0);

    for (int i = 0; i < PAIRS; i++)
        assert(!(read_flag[i] == 1 && read_data[i] == 0));

    assert(count() == PAIRS);

    return 0;
}