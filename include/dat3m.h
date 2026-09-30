extern int __VERIFIER_nondet_int(void);
extern int __VERIFIER_nondet_uint(void);
extern float  __VERIFIER_nondet_float(void);
extern double __VERIFIER_nondet_double(void);
extern _Bool __VERIFIER_nondet_bool(void);
extern void __VERIFIER_assume(int cond);
extern void __VERIFIER_assert(int cond);
extern void __VERIFIER_loop_bound(int);
extern unsigned int __VERIFIER_tid(void);

// DEPRECATED
#define __VERIFIER_loop_begin()
#define __VERIFIER_spin_start()
#define __VERIFIER_spin_end(v)

#define await_while(cond)                                                  \
    for (int tmp = (__VERIFIER_loop_begin(), 0); __VERIFIER_spin_start(),  \
        tmp = cond, __VERIFIER_spin_end(!tmp), tmp;)
