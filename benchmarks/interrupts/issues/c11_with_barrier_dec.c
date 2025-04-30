#include <stdlib.h>
#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>
#include <dat3m.h>

/*
    Discrepancy in vmm-interrupts.cat and vmm-interrupts-alt.cat
    The former gives FAIL which is likely wrong.
    The reason is that cnt-- cannot get reordered because assert induces a ctrl-dep (unlike __VERIFIER_assert).
    The generated witness is also very odd: it contains an event that is simultaneously before and after IH in terms
    of the communication relations.
*/

struct A { volatile int a; volatile int b; }; // Without "volatile" the compiler removes our assertions.
struct A as[10];
int cnt = 0;

pthread_t h;
void *handler(void *arg)
{
    int tindex = ((intptr_t) arg);
    int i = cnt++;
    __VERIFIER_make_cb();
    as[i].a = tindex;
    as[i].b = tindex;
    assert(as[i].a == as[i].b);

    cnt--;

    return NULL;
}

void *run(void *arg)
{
    __VERIFIER_register_interrupt_handler(handler);

    int tindex = ((intptr_t) arg);
    int i = cnt++;
    __VERIFIER_make_cb();
    as[i].a = tindex;
    as[i].b = tindex;
    assert(as[i].a == as[i].b);

    cnt--;

    return NULL;
}

int main()
{
    pthread_t t;
    pthread_create(&t, NULL, run, (void *)1);

    return 0;
}
