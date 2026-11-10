#include <limits.h>

/*
    Signed long long arithmetic checked by UBSan (-fsanitize=signed-integer-overflow).
    clang emits `call { i64, i1 } @llvm.sadd.with.overflow.i64`. On ILP32 targets (-m32),
    LLVM lays out { i64, i1 } in 12 bytes while Dartagnan's natural layout needs 16 bytes;
    the aggregate only lives in a register, so we could accept the program.

    Expected verdicts for no-overflow.prp (under both ILP32 and LP64):
      default:     true  (a < LLONG_MAX, so a + 1 cannot overflow)
      -DOVERFLOW:  false (a == LLONG_MAX is possible, so a + 1 overflows)
*/

extern void abort(void);
extern long long __VERIFIER_nondet_longlong(void);
void assume_abort_if_not(int cond) { if (!cond) { abort(); } }

int main(void) {
    long long a = __VERIFIER_nondet_longlong();
#ifndef OVERFLOW
    assume_abort_if_not(a < LLONG_MAX);
#endif
    long long b = a + 1;
    return b > a;
}
