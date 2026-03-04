#include <math.h>
#include <float.h>
#include <assert.h>
#include <dat3m.h>

#define GLOBAL

typedef union {
    float f;
    int i;
    struct {
        // Little endian
        short low;
        short high;
    };
} float_int;

#ifdef GLOBAL
float_int s;
#endif

int main(void) {
#ifndef GLOBAL
    float_int s;
#endif

    s.f = 5.0;
    s.low = s.low | 1; // set lowest mantissa bit
    s.high = s.high | (1 << 15); // set sign-bit
    assert (s.f == -5.000000476837158203125f);
    assert (s.i < 0);

    s.f *= -1.0f;
    assert(s.high > 0);
    assert(!signbit(s.f));

    return 0;
}
