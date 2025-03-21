#include <stdint.h>
#include <assert.h>
#include <dat3m.h>

int main()
{
    int x = 0;
    __VERIFIER_loop_bound(3);
    while (x != 5) {
        if (__VERIFIER_nondet_int() == 0) {
            x += 2;
        } else {
            x += 3;
        }
    }
    assert (0);

    return 0;
}
