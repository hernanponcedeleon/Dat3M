#include <stdlib.h>
#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>
#include <dat3m.h>

/*
    This test shows how interrupt handlers are spawned
*/

struct A { volatile int a; volatile int b; }; // Without "volatile" the compiler removes our assertions.
struct A as[10];
int cnt = 0;

pthread_t h;
void *handler(void *arg)
{
    int tindex = ((intptr_t) arg);
    __VERIFIER_disable_irq();
    int i = cnt++;
    as[i].a = tindex;
    as[i].b = tindex;
    assert(as[i].a == as[i].b);
    __VERIFIER_enable_irq();

    return NULL;
}

void *run(void *arg)
{
    __VERIFIER_make_interrupt_handler(); // Buggy without this marker
    pthread_create(&h, NULL, handler, 0);

    int tindex = ((intptr_t) arg);
    __VERIFIER_disable_irq();
    int i = cnt++;
    as[i].a = tindex;
    as[i].b = tindex;
    assert(as[i].a == as[i].b);
    __VERIFIER_enable_irq();

    pthread_join(h, NULL);

    return NULL;
}

int main()
{
    pthread_t t;
    pthread_create(&t, NULL, run, (void *)1);

    return 0;
}
