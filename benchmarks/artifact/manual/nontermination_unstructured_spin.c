#include <pthread.h>
#include <stdatomic.h>
#ifdef USE_GENMC
#define __VERIFIER_loop_bound(x)
#else
#include <dat3m.h>
#endif

/*
    Test case: Unstructured spin loop with complex entry point (derived from GPU code)
    Expected result: PASS under all memory models, but FAIL under weak progress models (HSA, OBE, UNFAIR).
*/

atomic_int x = 0;

void *thread(void *unused)
{
    LC00:
    if (x != 0) goto LC01;
    goto LC02;
    LC01:
    if (x != 0) goto LC02;
    goto LC01;
    LC02:
    if (x != 0) goto LC03;
    goto LC01;
    LC03:
    return 0;
}

void *thread2(void *unused) {
    x = 1;
}

int main()
{
    pthread_t t1, t2;
    pthread_create(&t1, NULL, thread, NULL);
    pthread_create(&t2, NULL, thread2, NULL);

    return 0;
}