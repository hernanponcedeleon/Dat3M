#include <stdint.h>
#include <assert.h>

volatile int32_t x = INT32_MAX+1;
volatile int32_t y = INT32_MAX-1;
volatile int32_t z = 1;
volatile int32_t u;

int main()
{
    // x = 1000 0000 0000 0000 0000 0000 0000 0000
    u = __builtin_ctz(x);
	assert(u == 31);
    // y = 1111 1111 1111 1111 1111 1111 1111 1110
    u = __builtin_ctz(y);
	assert(u == 1);
    // z = 0000 0000 0000 0000 0000 0000 0000 0001
    u = __builtin_ctz(z);
	assert(u == 0);

	return 0;
}
