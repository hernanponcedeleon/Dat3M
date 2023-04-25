#include "hash_table.h"
#include <pthread.h>
#include <assert.h>

#ifndef SETTERS
#define SETTERS 2
#endif

#ifndef GETTERS
#define GETTERS 2
#endif

#define NTHREADS (SETTERS + GETTERS)

void *setter(void *arg)
{
    uint32_t value = ((uint32_t) arg);
	set(value, value);
    return NULL;
}

void *getter(void *arg)
{
    uint32_t value = ((uint32_t) arg);
    uint32_t r = get(value);
	assert(r == value || r == 0);
    return NULL;
}

int main()
{
    pthread_t t[NTHREADS];

    init();

    for (int i = 0; i < SETTERS; i++)
        pthread_create(&t[i], 0, setter, (void *)i+1);

    for (int i = 0; i < GETTERS; i++)
        pthread_create(&t[SETTERS + i], 0, getter, (void *)i+1);

    for (int i = 0; i < NTHREADS; i++)
        pthread_join(t[i], 0);

    assert(count() == SETTERS);

    return 0;
}
