#include <pthread.h>

// The writer keeps its write lock, so the reader waits forever in pthread_rwlock_rdlock.
pthread_rwlock_t rw;

void *writer(void *unused)
{
    pthread_rwlock_wrlock(&rw);
    return 0;
}

void *reader(void *unused)
{
    pthread_rwlock_rdlock(&rw);
    pthread_rwlock_unlock(&rw);
    return 0;
}

int main()
{
    pthread_t t1, t2;
    pthread_rwlock_init(&rw, 0);
    pthread_create(&t1, NULL, writer, NULL);
    pthread_create(&t2, NULL, reader, NULL);
    return 0;
}
