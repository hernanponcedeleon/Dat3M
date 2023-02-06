#include <stdlib.h>
#include <assert.h>

// This test makes sure that we do not accidentally cut of side-effect-full loops
// whose side-effects were propagated by constant propagation
// Expected result: FAIL with B >= 3, UNKNOWN otherwise

volatile int bound = 2; // To stop the compiler from optimising away our loop

int main()
{
	int cnt = 0;
	while (cnt++ < bound) { }
	assert (0); // FAIL, unless we cut of the loop too early

	return 0;
}
