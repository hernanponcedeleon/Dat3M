// Currently, clspv inserts Coherent decorations only if accesses are separated
// by a global control barrier, ignoring release-acquire synchronization.
// To work around this, we manually insert Coherent decoration for variable 'in'
// for tests with a local barrier (with LOCAL flag) before upgrading the memory model.

// Default, without LOCAL barrier flag:
// clspv xf-barrier.cl --cl-std=CL2.0 --inline-entry-points --spv-version=1.6
// spirv-opt --upgrade-memory-model a.spv -o a.spv
// spirv-dis a.spv > xf-barrier.spvasm

// With LOCAL barrier flag:
// clspv xf-barrier.cl --cl-std=CL2.0 --inline-entry-points --spv-version=1.6
// spirv-dis a.spv > xf-barrier.spvasm
// Add 'OpDecorate %20 Coherent' (id might be different depending on clspv version)
// spirv-as xf-barrier.spvasm -o a.spv
// spirv-opt --upgrade-memory-model a.spv -o a.spv
// spirv-dis a.spv > xf-barrier.spvasm

#ifdef FAIL1
#define mo1 memory_order_relaxed
#else
#define mo1 memory_order_acquire
#endif

#ifdef FAIL2
#define mo2 memory_order_relaxed
#else
#define mo2 memory_order_release
#endif

#ifdef FAIL3
#define mo3 memory_order_relaxed
#else
#define mo3 memory_order_release
#endif

#ifdef FAIL4
#define mo4 memory_order_relaxed
#else
#define mo4 memory_order_acquire
#endif

#ifdef LOCAL
#define sem CLK_LOCAL_MEM_FENCE
#else
#define sem CLK_GLOBAL_MEM_FENCE
#endif

__kernel void xf_barrier(global atomic_uint *flag, global uint* in, global uint* out) {

        unsigned int group_id = get_group_id(0);
        unsigned int local_id = get_local_id(0);
        unsigned int num_groups = get_num_groups(0);

        unsigned int global_id = get_global_id(0);
        unsigned int global_size = get_global_size(0);

        in[global_id] = 1;

        if (group_id == 0) {
            if (local_id + 1 < num_groups) {
                while (atomic_load_explicit(&flag[local_id + 1], mo1) == 0);
            }
            barrier(sem);
            if (local_id + 1 < num_groups) {
                atomic_store_explicit(&flag[local_id + 1], 0, mo2);
            }
        } else {
            barrier(sem);
            if (local_id == 0) {
                atomic_store_explicit(&flag[group_id], 1, mo3);
                while (atomic_load_explicit(&flag[group_id], mo4) == 1);
            }
            barrier(sem);
        }

        for (unsigned int i = 0; i < global_size; i++) {
            out[global_id] += in[i];
        }
}