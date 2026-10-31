#include <assert.h>
#include <stdbool.h>
#include <dat3m.h>

/*
    Tests that removing dead conditional jumps does not remove a jump that is reached by falling
    through a conditional jump with the opposite guard: falling through "if (c) goto L" means that
    c does not hold, so "while (!c)" below must still be entered.
    The store to "dead_if_c" is removed during processing, which leaves "if (c) goto L; L: if (!c) ...".
    Same as fallThroughCondJump, but the assertion fails when c does not hold.
    EXPECTED: FAIL
*/

int main()
{
    bool c = __VERIFIER_nondet_bool();
    int dead_if_c = 0;
    if (c)
        goto L;
    dead_if_c = 5;
L:
    while (!c) {
        assert(0);
        break;
    }
    return 0;
}
