#include <stdlib.h>
#include <pthread.h>
#include <assert.h>
#include <lkmm.h>

int x;
int y;

int r0, r1;

void *thread_1(void *unused)
{
	WRITE_ONCE(r0,  READ_ONCE(x));
	if (READ_ONCE(r0))
		WRITE_ONCE(y, 1);
	return NULL;
}

void *thread_2(void *unused)
{
	WRITE_ONCE(r1, READ_ONCE(y));
	smp_mb();
	WRITE_ONCE(x, 1);
	return NULL;
}

int main()
{
	pthread_t t1, t2;

	pthread_create(&t1, NULL, thread_1, NULL);
	pthread_create(&t2, NULL, thread_2, NULL);

	pthread_join(t1, NULL);
	pthread_join(t2, NULL);

	assert(!(READ_ONCE(r0) == 1 && READ_ONCE(r1) == 1));

	return 0;
}
