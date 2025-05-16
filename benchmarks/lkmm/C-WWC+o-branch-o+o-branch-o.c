#include <stdlib.h>
#include <pthread.h>
#include <assert.h>
#include <lkmm.h>

atomic_t x;
atomic_t y;

int r1_0;
int r3_0;

int r2_1;
int r4_1;

void *thread_1(void *unused)
{
	r1_0 = atomic_read(&x);
	r3_0 = (r1_0 != 0);
	if (r3_0) {
		atomic_set(&y, 1);
	}
    return NULL;
}

void *thread_2(void *unused)
{
	r2_1 = atomic_read(&y);
	r4_1 = (r2_1 != 0);
	if (r4_1) {
		atomic_set(&x, 1);
	}
    return NULL;
}

void *thread_3(void *unused)
{
	atomic_set(&x, 2);
    return NULL;
}

int main()
{
	pthread_t t1, t2, t3;

	pthread_create(&t1, NULL, thread_1, NULL);
	pthread_create(&t2, NULL, thread_2, NULL);
	pthread_create(&t3, NULL, thread_3, NULL);

	pthread_join(t1, NULL);
	pthread_join(t2, NULL);
	pthread_join(t3, NULL);

	assert(!(r1_0 == 2 && r2_1 == 1 && atomic_read(&x) == 2));

	return 0;
}
