#include <stdlib.h>
#include <pthread.h>
#include <assert.h>
#include <stdatomic.h>

int a, b, x, y;

void *thread_1(void *unused)
{
    x = 1;
    asm volatile ("lwsync" ::: "memory");
    a = y;
    return NULL;
}

void *thread_2(void *unused)
{
    y = 1;
    asm volatile ("sync" ::: "memory");
    b = x;
    return NULL;
}

int main()
{
	pthread_t t1, t2;

	pthread_create(&t1, NULL, thread_1, NULL);
	pthread_create(&t2, NULL, thread_2, NULL);

	pthread_join(t1, NULL);
	pthread_join(t2, NULL);

	assert(!(a == 0 && b == 0));

	return 0;
}
