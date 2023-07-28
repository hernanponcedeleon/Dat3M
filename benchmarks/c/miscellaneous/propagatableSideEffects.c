#include <stdlib.h>
#include <assert.h>
#include <dat3m.h>

// This test makes sure that we do not accidentally cut off side-effect-full loops
// whose side-effects were propagated by constant propagation
// Expected result: FAIL with B >= 3, UNKNOWN otherwise

#ifndef B
#define B 3
#endif

volatile int bound = B - 1; // To stop the compiler from optimising away our loop

int main()
{
	int cnt = 0;
	__VERIFIER_loop_bound(B);
	while (cnt++ < bound) { }
	assert (0); // FAIL, unless we cut off the loop too early

	return 0;
}
