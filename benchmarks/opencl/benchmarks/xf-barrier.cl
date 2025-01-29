// clspv xf-barrier.cl --cl-std=CL2.0 --inline-entry-points --spv-version=1.6
// spirv-dis a.spv

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
            barrier(CLK_GLOBAL_MEM_FENCE);
            if (local_id + 1 < num_groups) {
                atomic_store_explicit(&flag[local_id + 1], 0, mo2);
            }
        } else {
            barrier(CLK_GLOBAL_MEM_FENCE);
            if (local_id == 0) {
                atomic_store_explicit(&flag[group_id], 1, mo3);
                while (atomic_load_explicit(&flag[group_id], mo4) == 1);
            }
            barrier(CLK_GLOBAL_MEM_FENCE);
        }

        for (unsigned int i = 0; i < global_size; i++) {
            out[global_id] += in[i];
        }
}
