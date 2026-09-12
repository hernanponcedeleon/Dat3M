//; @Input: %flag = {{0, 0, 0, 0, 0, 0, 0, 0}}
//; @Input: %in = {{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}}
//; @Input: %out = {{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}}
//; @Output: forall (%out[0][0] == 4 and %out[0][1] == 4 and %out[0][2] == 4 and %out[0][3] == 4)
//; @Config: 2, 1, 2

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
