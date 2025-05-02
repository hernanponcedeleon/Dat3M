#include <stdlib.h>
#include <lkmm.h>
#include <pthread.h>
#include <assert.h>
#include <dat3m.h>

// ISSUE: Two-channel Message Passing with the sender fence inside the interrupt handler.
// Expected: PASS because the interrupt point is constrained to be convenient for at least one channel (a or b).
int x, y, a1, a2, b1, b2;
int r1, r2, t1, u1, t2, u2;

pthread_t h;
void *handler(void *arg)
{
    r1 = READ_ONCE(x);
    smp_wmb();
    r2 = READ_ONCE(y);
    return NULL;
}

void *thread_1(void *arg)
{
    __VERIFIER_register_interrupt_handler(handler);

    WRITE_ONCE(b1, 1);
    WRITE_ONCE(x, 1);
    WRITE_ONCE(a1, 1);
    WRITE_ONCE(b2, 1);
    WRITE_ONCE(y, 1);
    WRITE_ONCE(a2, 1);

    __VERIFIER_disable_irq();
    return NULL;
}

void *thread_2(void *arg)
{
    t1 = READ_ONCE(a2);
    u1 = READ_ONCE(b2);
    smp_rmb();
    t2 = READ_ONCE(a1);
    u2 = READ_ONCE(b1);
    return NULL;
}

int main()
{
    pthread_t thread1, thread2;

    pthread_create(&thread1, 0, thread_1, NULL);
    pthread_create(&thread2, 0, thread_2, NULL);
    pthread_join(thread1, 0);
    pthread_join(thread2, 0);

    int reorder_bx = (t1 == 1 && t2 == 0);
    int reorder_ya = (u1 == 1 && u2 == 0);
    if (r1 == 1 && r2 == 0) {
        __VERIFIER_assert(! reorder_bx || ! reorder_ya);
    }

    return 0;
}
