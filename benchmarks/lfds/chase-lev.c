#include <chase-lev.h>
#include <pthread.h>
#include <assert.h>

#ifndef NUM
#define NUM 10
#endif

#ifndef THIEFS
#define THIEFS 4
#endif

struct Deque deq;
pthread_t thiefs[THIEFS];

void *thief(void *unused)
{
    int data;
    try_steal(&deq, NUM, &data);
    return NULL;
}

void *owner(void *unused)
{
    int count = 0;
    int data;

    count++;
    try_push(&deq, NUM, count);

#ifdef FAIL
    pthread_t t;
    pthread_create(&t, NULL, thief, NULL);
#endif
    // Unless the thief thread was created above, I should pop the value that I just pushed
    try_pop(&deq, NUM, &data);
    assert(data == count);

    for (int i = 0; i <= THIEFS; i++)
        try_push(&deq, NUM, count);

    for (int i = 0; i < THIEFS; i++)
        pthread_create(&thiefs[i], NULL, thief, NULL);

    // The  number of pop + steal == push to this holds
    assert(try_pop(&deq, NUM, &data) >= 0);

    return NULL;
}

int main()
{
	pthread_t t0;

	pthread_create(&t0, NULL, owner, NULL);
    return 0;
}
