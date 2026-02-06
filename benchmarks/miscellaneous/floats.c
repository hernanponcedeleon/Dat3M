#include <math.h>
#include <float.h>
#include <assert.h>
#include <dat3m.h>

/* Test selector */
#ifndef TEST_ID
#define TEST_ID 1
#endif

int main(void) {
    float  f = __VERIFIER_nondet_float();
    double d = __VERIFIER_nondet_double();

#if TEST_ID == 1
    /* --- NaN identity --- */
    if (isnan(f)) assert(f != f);
    if (isnan(d)) assert(d != d);

#elif TEST_ID == 2
    /* --- Infinity propagation --- */
    if (isinf(f)) assert(isinf(f + 1.0f));
    if (isinf(d)) assert(isinf(d + 1.0));

#elif TEST_ID == 3
    /* --- Signed zero (division) --- */
    if (f == 0.0f && !signbit(f)) {
        float inv = 1.0f / f;
        assert(isinf(inv));
        // assert(!signbit(inv)); // TODO: we currently FAIL this one, probably due to the lack of support for sign in INF
    }
    if (f == 0.0f && signbit(f)) {
        float inv = 1.0f / f;
        assert(isinf(inv));
        assert(signbit(inv));
    }

#elif TEST_ID == 4
    /* --- Overflow --- */
    if (fabs(d) > DBL_MAX / 2.0) {
        double x = d + d;
        assert(isinf(x));
    }
    if (fabs(d) > DBL_MAX - 1.0) {
        double x = d + 1.0;
        assert(isinf(x));
    }

#elif TEST_ID == 5
    /* --- Underflow / subnormals --- */
    if (fabs(d) <= DBL_MIN) {
        double x = d / 2.0;
        assert(fabs(x) < DBL_MIN);
#ifdef FAIL
        assert(x != 0.0);
#endif
    }

#elif TEST_ID == 6
    /* --- Cancellation --- */
    if (!isnan(d) && !isinf(d)) {
        double x = d + 1e-300;
        double y = x - d;
        assert(y >= 0.0);
#ifdef FAIL
        assert(y != 0.0);
#endif
    }

#elif TEST_ID == 7
    /* --- NaN propagation --- */
    if (isnan(d)) {
        assert(isnan(d + 1.0));
        assert(isnan(d * 2.0));
        assert(!(d == d));
        assert(!(d < 0.0));
        assert(!(d > 0.0));
    }

#elif TEST_ID == 8
    /* --- Signed zero arithmetic --- */
    if (f == 0.0f) {
        float z1 = f + f;
        assert(z1 == 0.0f);
        assert(signbit(z1) == signbit(f));

        float z2 = f * 1.0f;
        assert(z2 == 0.0f);
        assert(signbit(z2) == signbit(f));
    }

#elif TEST_ID == 9
    /* --- fmin / fmax corner cases --- */
    if (isnan(d)) {
        assert(fmin(d, 1.0) == 1.0);
        assert(fmax(d, 1.0) == 1.0);
    }
    if (d == 0.0 && signbit(d)) {
        double m = fmax(d, +0.0);
        assert(!signbit(m));
    }

#elif TEST_ID == 10
    /* --- Rounding / absorption --- */
    if (!isnan(d) && !isinf(d) && fabs(d) > 1e100) {
        double x = d + 1.0;
        assert(x == d);
    }

#elif TEST_ID == 11
    /* --- Non-associativity --- */
    {
        double a = 1e308;
        double b = -1e308;
        double c = 1.0;
        double r1 = (a + b) + c;
        double r2 = a + (b + c);
        assert(r1 != r2);
    }

#elif TEST_ID == 12
    /* --- Comparison corner cases --- */
    if (!isnan(f)) {
        assert(!(f < f));
        assert(!(f > f));
    }
    if (isnan(f)) {
        assert(!(f == f));
        assert(!(f < 1.0f));
        assert(!(f > 1.0f));
    }

#elif TEST_ID == 13
    /* --- float vs double narrowing --- */
    {
        float ff = (float)1e-300;
        assert(ff == 0.0f);
    }

#elif TEST_ID == 14
    /* --- Division corner cases --- */
    if (!isnan(d) && !isinf(d) && d != 0.0) {
        double x = d / d;
        assert(x == 1.0);
    }
    if (d == 0.0) {
        double x = d / d;
        assert(isnan(x));
    }

#else
#error "Unknown TEST_ID"
#endif

    return 0;
}
