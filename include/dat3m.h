extern int __VERIFIER_nondet_int(void);
extern int __VERIFIER_nondet_uint(void);
extern _Bool __VERIFIER_nondet_bool(void);
extern void __VERIFIER_assume(int cond);
extern void __VERIFIER_assert(int cond);
extern void __VERIFIER_loop_bound(int);
extern unsigned int __VERIFIER_tid(void);

// Used for spinloops
extern void __VERIFIER_loop_begin(void);
extern void __VERIFIER_spin_start(void);
extern void __VERIFIER_spin_end(int);

#define await_while(cond)                                                  \
    for (int tmp = (__VERIFIER_loop_begin(), 0); __VERIFIER_spin_start(),  \
        tmp = cond, __VERIFIER_spin_end(!tmp), tmp;)
