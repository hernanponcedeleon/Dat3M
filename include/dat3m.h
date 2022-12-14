extern int __VERIFIER_nondet_int(void);
extern void __VERIFIER_assume(int cond);
extern void __VERIFIER_loop_bound(int);

// Used for spinloops
extern void __VERIFIER_loop_begin(void);
extern void __VERIFIER_spin_start(void);
extern void __VERIFIER_spin_end(int);

#define await_while(cond)                                                  \
    for (int tmp = (__VERIFIER_loop_begin(), 0); __VERIFIER_spin_start(),  \
        tmp = cond, __VERIFIER_spin_end(!tmp), tmp;)
