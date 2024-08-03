#include <stdint.h>
#include <assert.h>

#define INCS 3

volatile int32_t x = 0;

int main()
{
    for (int i = 0; i < INCS; i++)
        x++;

    for (int i = -1; i < INCS-1; i++)
        x++;

    for (int i = 1; i < INCS+1; i++)
        x++;

	assert(x == 3*INCS);

	return 0;
}
