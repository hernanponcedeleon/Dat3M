#include <pthread.h>
#include <assert.h>
#include <lkmm.h>

int x;
atomic_t y;

// FAIL: Non-value-returning RMWs do not contribute to release sequences in LKMM.
// Hence the acq-read does not synchronize with the rel-write 

void *run(void *arg)
{
    int tid = ((intptr_t) arg);
    switch (tid) {
    case 0:
        x = 1;
        smp_store_release(&y.counter, 0x3);
        break;
    case 1:
        atomic_andnot(0x2, &y);
        break;
    case 2:
        if (smp_load_acquire(&y.counter) == 0x1) {
            assert (x == 1);
        }
        break;
    }
    return NULL;
}
int main()
{
    pthread_t t0, t1, t2;
    pthread_create(&t0, NULL, run, (void *) 0);
    pthread_create(&t1, NULL, run, (void *) 1);
    pthread_create(&t2, NULL, run, (void *) 2);
    
    pthread_join(t0, 0);
    pthread_join(t1, 0);
    pthread_join(t2, 0);

    return 0;
}
