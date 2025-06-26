#include <stdint.h>
#include <strings.h>
#include <assert.h>
#include <limits.h>

volatile int32_t x = 1;
volatile int32_t y = 0;
volatile int32_t w = INT32_MAX;
volatile int32_t z = INT32_MAX+1;
volatile int32_t u;

volatile long lx = 1;
volatile long ly = 0;
volatile long lw = LONG_MAX;
volatile long lz = LONG_MAX+1;
volatile long lu;

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

    // lx = 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0001
    lu = ffsl(lx);
    assert(lu == 1);
    // ly = 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000
    lu = ffsl(ly);
    assert(lu == 0);
    // lw = 0111 1111 1111 1111 1111 1111 1111 1111 1111 1111 1111 1111 1111 1111 1111 1111
    lu = ffsl(lw);
    assert(lu == 1);
    // lz = 1000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000
    lu = ffsl(lz);
    assert(lu == 64);

    return 0;
}
