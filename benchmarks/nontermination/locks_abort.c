#include <pthread.h>
#include <stdatomic.h>
#include <dat3m.h>

pthread_mutex_t m;

void *thread(void *unused)
{
    pthread_mutex_lock(&m);
    if(__VERIFIER_nondet_bool()) {
        abort();
    }
    pthread_mutex_unlock(&m);
    return 0;
}

int main()
{
    pthread_t t1, t2;
    pthread_mutex_init(&m, 0);
    pthread_create(&t1, NULL, thread, NULL);
    pthread_create(&t2, NULL, thread, NULL);

    return 0;
}