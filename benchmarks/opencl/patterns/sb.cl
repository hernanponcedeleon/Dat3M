//; @Input: %x = {{0}}
//; @Input: %y = {{0}}
//; @Input: %r0 = {{0}}
//; @Input: %r1 = {{0}}
//; @Output: exists (%r0[0][0] == 0 and %r1[0][0] == 0)
//; @Config: 2, 1, 1

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

__kernel void test(global atomic_uint* x, global atomic_uint* y, global uint* r0, global uint* r1) {
    if (get_local_id(0) == 0) {
        atomic_store_explicit(x, 1, mo_rel);
        *r0 = atomic_load_explicit(y, mo_acq);
    } else {
        atomic_store_explicit(y, 1, mo_rel);
        *r1 = atomic_load_explicit(x, mo_acq);
    }
}
