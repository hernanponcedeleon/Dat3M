#include <stdlib.h>
#include <pthread.h>
#include <assert.h>
#include <dat3m.h>
#include <lkmm.h>

int x, y, z;

pthread_t h;
void *handler(void *arg)
{
    WRITE_ONCE(z, 3);
    assert(READ_ONCE(y) == 0);
    return NULL;
}

void *thread_1(void *arg)
{
    __VERIFIER_make_interrupt_handler();
    pthread_create(&h, NULL, handler, NULL);

    if(READ_ONCE(x) == 1) {
        WRITE_ONCE(y, 2);
    }

    pthread_join(h, 0);

    return NULL;
}

void *thread_2(void *arg)
{
    if(READ_ONCE(z) == 3) {
        WRITE_ONCE(x, 1);
    }
    return NULL;
}

int main()
{
    pthread_t t1, t2;

    pthread_create(&t1, 0, thread_1, NULL);
    pthread_create(&t2, 0, thread_2, NULL);

    return 0;
}
