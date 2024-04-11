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

__kernel void xf_barrier(global atomic_uint *flag, global uint* data_leaders, global uint* read_data_leaders, global uint* data_followers, global uint* read_data_followers, global uint* done_leaders, global uint* done_followers) {

        if (get_group_id(0) == 0) {

            data_leaders[get_local_id(0)] = 1;

            // The 2 in the comparison should be eventually replaced by get_num_groups(0) 
            // and should match the last entry of the config in the spirv code
            if (get_local_id(0) + 1 < 2) {
                while (atomic_load_explicit(&flag[get_local_id(0) + 1], mo1) == 0);
            }

            barrier(CLK_GLOBAL_MEM_FENCE);

            // The 2 in the comparison should be eventually replaced by get_num_groups(0) 
            // and should match the last entry of the config in the spirv code
            if (get_local_id(0) + 1 < 2) {
                atomic_store_explicit(&flag[get_local_id(0) + 1], 0, mo2);
            }

            read_data_followers[get_local_id(0)] = data_followers[get_local_id(0)];
            done_leaders[get_local_id(0)] = 1;

        } else {

            data_followers[get_local_id(0)] = 1;

            barrier(CLK_GLOBAL_MEM_FENCE);

            if (get_local_id(0) == 0) {
                atomic_store_explicit(&flag[get_group_id(0)], 1, mo3);
                while (atomic_load_explicit(&flag[get_group_id(0)], mo4) == 1);
            }

            barrier(CLK_GLOBAL_MEM_FENCE);

            read_data_leaders[get_local_id(0)] = data_leaders[get_local_id(0)];
            done_followers[get_local_id(0)] = 1;

        }
}
