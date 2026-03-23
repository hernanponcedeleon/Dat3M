#include <pthread.h>
#include <assert.h>
#include "dat3m.h"

// NOTE: This version of CNA is different to the one found in "benchmarks/locks/"
// It comes from an implementation from "Universität Hannover"

/*
    This code exposed a bug fixed by https://github.com/hernanponcedeleon/Dat3M/pull/1014:
    The following Dartagnan configuration would sometimes fail to be conclusive
        <dat3m> cat/sc.cat client.c --method=lazy --bound=3 --encoding.integers=true --property=termination
 */

 /*
    This benchmark shows interesting performance characteristics with
                            sc.cat  --bound=3 --solver=z3
    The bound is needed to get PASS.

    (1) --method=eager seems to be a lot better than lazy (depending on config, but can be >5x faster)
        This suggests that data-flow reasoning is hard for some reason.
        with "--refinement.baseline=NO_OOTA", the solving times become similar again.
    (2) For eager, "--encoding.wmm.idl2sat=true" is a lot faster than IDL (at least 5x faster?)
    (3) Effect of "--encoding.integers=true" is unclear
    (4) with #define FAIL, the code still satisfies program_spec (only termination fails) under SC.
        However, verifying this is substantially(!) slower than the correct version.
        Code-wise, the FAIL variant is only slightly larger.

     Fastest configs:
         --method=eager --encoding.wmm.idl2sat=true
     AND --method=lazy  --encoding.wmm.idl2sat=true --refinement.baseline=NO_OOTA
 */

//#define FAIL          // Enable buggy version: termination violation under SC,
                        // program_spec/data-races under weaker models.
#include "cna.h"

#ifndef NTHREADS
#define NTHREADS 4      // Need 4 threads to find the bugs!
#endif

lock_t my_lock;
__thread lock_handle_t handle;
int sum = 0;


void *thread_n(void *arg)
{
    // Assign arbitrary numa id to test all numa configurations
    thread_numa_id = __VERIFIER_nondet_uint();

    cna_lock(&my_lock, &handle);
    sum++;
    cna_unlock(&my_lock, &handle);
    return NULL;
}
 
int main()
{
    cna_init(&my_lock);

    pthread_t t[NTHREADS];
 
    for (int i = 0; i < NTHREADS; i++)
        pthread_create(&t[i], NULL, thread_n, NULL);

    for (int i = 0; i < NTHREADS; i++)
        pthread_join(t[i], NULL);

    // If mutual exclusion is violated, an increment can get lost
    assert(sum == NTHREADS);
 
    return 0;
}
