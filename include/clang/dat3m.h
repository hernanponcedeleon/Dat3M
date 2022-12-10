extern int __VERIFIER_nondet_int(void);
extern void __VERIFIER_assume(int cond);

// Used for spinloops
extern void __VERIFIER_loop_begin(void);
extern void __VERIFIER_spin_start(void);
extern void __VERIFIER_spin_end(int);
extern void __VERIFIER_loop_bound(int);

#define await_while(cond)                                                  \
    for (int tmp = (__VERIFIER_loop_begin(), 0); __VERIFIER_spin_start(),  \
        tmp = cond, __VERIFIER_spin_end(!tmp), tmp;)
