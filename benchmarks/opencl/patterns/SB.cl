// clspv SB.cl --cl-std=CL2.0 --inline-entry-points --spv-version=1.6
// spirv-dis a.spv

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
