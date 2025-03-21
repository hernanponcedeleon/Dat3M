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

// Used for interrupt model
extern void __VERIFIER_make_interrupt_handler(void);
extern void __VERIFIER_disable_irq(void);
extern void __VERIFIER_enable_irq(void);
extern void __VERIFIER_make_cb(void);

extern int __VERIFIER_racy_read(int*);
extern void __VERIFIER_racy_write(int*, int);

#define await_while(cond)                                                  \
    for (int tmp = (__VERIFIER_loop_begin(), 0); __VERIFIER_spin_start(),  \
        tmp = cond, __VERIFIER_spin_end(!tmp), tmp;)
