#include <stdint.h>
#include <strings.h>
#include <assert.h>

volatile int32_t x = 1;
volatile int32_t y = 0;
volatile int32_t w = INT32_MAX;
volatile int32_t z = INT32_MAX+1;
volatile int32_t u;

int main()
{
    // x = 0000 0000 0000 0000 0000 0000 0000 0001
    u = ffs(x);
	assert(u == 1);
    // y = 0000 0000 0000 0000 0000 0000 0000 0000
    u = ffs(y);
	assert(u == 0);
    // w = 0111 1111 1111 1111 1111 1111 1111 1111
    u = ffs(w);
	assert(u == 1);
    // z = 1000 0000 0000 0000 0000 0000 0000 0000
    u = ffs(z);
	assert(u == 32);

	return 0;
}
