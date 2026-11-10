#include <assert.h>
#include <stdatomic.h>

/*
    Compare-exchange on a long long.
    clang emits `cmpxchg { i64, i1 } `
*/

atomic_llong x;

int main(void) {
    long long expected = 0;
    assert(atomic_compare_exchange_strong(&x, &expected, 42));
    return 0;
}
