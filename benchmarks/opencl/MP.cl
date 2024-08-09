// clspv MP.cl --cl-std=CL2.0 --inline-entry-points --spv-version=1.6
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

__kernel void test(global atomic_uint* flag, global uint* data, global uint* r0, global uint* r1) {
    if (get_global_id(0) == 0) {
        *data = 1;
        atomic_store_explicit(flag, 1, mo_rel);
    } else {
        *r0 = atomic_load_explicit(flag, mo_acq);
        *r1 = *data;
    }
}
