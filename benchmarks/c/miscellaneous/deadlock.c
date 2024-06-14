#include <pthread.h>
#include <assert.h>

pthread_mutex_t mutex;

void *thread(void *unused)
{
    pthread_mutex_lock(&mutex);
	return NULL;
}

int main()
{
	pthread_t t1, t2;

    pthread_mutex_init(&mutex, 0);

	pthread_create(&t1, NULL, thread, NULL);
	pthread_create(&t2, NULL, thread, NULL);

	pthread_join(t1, NULL);
	pthread_join(t2, NULL);

	assert(0);

	return 0;
}
