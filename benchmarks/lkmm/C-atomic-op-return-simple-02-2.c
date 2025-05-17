#include <stdlib.h>
#include <pthread.h>
#include <assert.h>
#include <lkmm.h>

atomic_t x;
atomic_t y;

int r0_0;
int r1_0;

int r0_1;
int r1_1;

void *thread_1(void *unused)
{
  r0_0 = atomic_add_return_relaxed(1,&x);
  r1_0 = atomic_read(&y);
  return NULL;
}

void *thread_2(void *unused)
{
  r0_1 = atomic_add_return_relaxed(1,&y);
  r1_1 = atomic_read(&x);
  return NULL;
}

int main()
{
	pthread_t t1, t2;

	pthread_create(&t1, NULL, thread_1, NULL);
	pthread_create(&t2, NULL, thread_2, NULL);

	pthread_join(t1, NULL);
	pthread_join(t2, NULL);

	assert(!(r0_0 == 1 && r1_0 == 0 && r0_1 == 1 && r1_1 == 0 && atomic_read(&x) == 1 && atomic_read(&y) == 1));

	return 0;
}
