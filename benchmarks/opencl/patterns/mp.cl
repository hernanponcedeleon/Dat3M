// Currently, clspv inserts Coherent decorations only if accesses are separated
// by a global control barrier, ignoring release-acquire synchronization.
// To work around this, we manually insert Coherent decoration for variable 'data'
// before upgrading the memory model.

// clspv mp.cl --cl-std=CL2.0 --inline-entry-points --spv-version=1.6
// spirv-dis a.spv > mp.spvasm
// Add 'OpDecorate %18 Coherent' (id might be different depending on clspv version)
// spirv-as mp.spvasm -o a.spv
// spirv-opt --upgrade-memory-model a.spv -o a.spv
// spirv-dis a.spv > mp.spvasm

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
