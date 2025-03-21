#include <assert.h>
#include <dat3m.h>

int main()
{
	unsigned int x = __VERIFIER_nondet_uint();
A:
	if (x >= 1) {
		x = 4;
		goto B;
	} else {
		goto C;
	}
B:
	// 3, 4, 5, 6
	if (x > 3) {
		goto D;
	} else {
		goto E;
	}
D:
	// 3, 4, 5, 6
	x++;

	if (x > 5) {
		goto Halt;
	} else {
		goto E;
	}
E:
	// 3, 4, 5
	if (x < 4) {
		goto D;
	} else {
		goto F;
	}
F:
	// 4, 5
	if (x < 3) {
		goto C;
	} else {
		goto G;
	}
G:
	// 0, 1, 2, 4, 5
	x++;
	goto C;
C:
	// 0, 1, 2, 3, 5, 6
	if (x > 2) {
		goto B;
	} else {
		goto G;
	}
Halt:
	// 6, 7
	assert(x == 6);
}