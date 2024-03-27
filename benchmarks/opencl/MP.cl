#ifdef ACQ2RX
#define mo_acq memory_order_relaxed
#else
#define mo_acq memory_order_acquire
#endif
#ifdef REL2RX
#define mo_rel memory_order_relaxed
#else
#define mo_rel memory_order_release
#endif

__kernel void test(global atomic_uint* f, global uint* x, global uint* r0, global uint* r1) {
    // T0
    if (get_global_id(0) == 0) {
        *x = 1;
        atomic_store_explicit(f, 0, mo_rel);
    }
    // T1
    if (get_global_id(0) == 1) {
        *r0 = atomic_load_explicit(f, mo_acq);
        *r1 = *x;
    }
} 
