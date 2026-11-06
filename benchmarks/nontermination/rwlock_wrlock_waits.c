#include <pthread.h>

// The reader keeps its read lock, so the writer waits forever in pthread_rwlock_wrlock.
pthread_rwlock_t rw;

void *reader(void *unused)
{
    pthread_rwlock_rdlock(&rw);
    return 0;
}

void *writer(void *unused)
{
    pthread_rwlock_wrlock(&rw);
    pthread_rwlock_unlock(&rw);
    return 0;
}

int main()
{
    pthread_t t1, t2;
    pthread_rwlock_init(&rw, 0);
    pthread_create(&t1, NULL, reader, NULL);
    pthread_create(&t2, NULL, writer, NULL);
    return 0;
}
