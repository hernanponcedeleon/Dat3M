#ifdef RX
#define mo_acq memory_order_relaxed
#define mo_rel memory_order_relaxed
#else
#define mo_acq memory_order_acquire
#define mo_rel memory_order_release
#endif

__kernel void xf_barrier(global atomic_uint *flag, global uint* x, global uint* y) {

        if (get_group_id(0) == 0) {

            if (get_local_id(0) == 0) {
                *x = 1;
            }

            if (get_local_id(0) + 1 < get_num_groups(0)) {
                while (atomic_load_explicit(&flag[get_local_id(0) + 1], memory_order_relaxed) == 0);
            }

            barrier(CLK_GLOBAL_MEM_FENCE);

            if (get_local_id(0) + 1 < get_num_groups(0)) {
                atomic_store_explicit(&flag[get_local_id(0) + 1], 0, mo_rel);
            }

        } else {

            barrier(CLK_GLOBAL_MEM_FENCE);

            if (get_local_id(0) == 0) {
                atomic_store_explicit(&flag[get_group_id(0)], 1, memory_order_relaxed);
                while (atomic_load_explicit(&flag[get_group_id(0)], mo_acq) == 1);
            }

            barrier(CLK_GLOBAL_MEM_FENCE);

            if (get_local_id(0) == 0) {
                *y = *x;
            }
        }
}
