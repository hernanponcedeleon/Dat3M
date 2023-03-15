#include <stdint.h>
#include <assert.h>

volatile int32_t x = 1;
volatile int32_t y = INT32_MAX;
volatile int32_t z = INT32_MAX+1;
volatile int32_t u;

int main()
{
    // x = 0000 0000 0000 0000 0000 0000 0000 0001 
    u = __builtin_clz(x);
	assert(u == 31);
    // y = 0111 1111 1111 1111 1111 1111 1111 1111 
    u = __builtin_clz(y);
	assert(u == 1);
    // z = 1000 0000 0000 0000 0000 0000 0000 0000 
    u = __builtin_clz(z);
	assert(u == 0);

	return 0;
}
