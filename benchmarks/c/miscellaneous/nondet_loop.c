#include <stdint.h>
#include <assert.h>

int main()
{
    int x = 0;
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
