#include <pthread.h>

// Every lock is released, so every thread terminates.
pthread_rwlock_t rw;
int value;

void *reader(void *unused)
{
    pthread_rwlock_rdlock(&rw);
    (void)value;
    pthread_rwlock_unlock(&rw);
    return 0;
}

void *writer(void *unused)
{
    pthread_rwlock_wrlock(&rw);
    value = 1;
    pthread_rwlock_unlock(&rw);
    return 0;
}

int main()
{
    pthread_t t1, t2, t3;
    pthread_rwlock_init(&rw, 0);
    pthread_create(&t1, NULL, reader, NULL);
    pthread_create(&t2, NULL, reader, NULL);
    pthread_create(&t3, NULL, writer, NULL);
    return 0;
}
