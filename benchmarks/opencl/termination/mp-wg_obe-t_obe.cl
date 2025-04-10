__kernel void test(global atomic_uint* dev_flag, local atomic_uint* wg_flag, global atomic_uint* wg_counter, local atomic_uint* t_counter) {

    __local uint wg_ticket;
    uint group_id;
    uint local_id = atomic_fetch_add_explicit(t_counter, 1, memory_order_acq_rel);

    // Initialize the id of each WG
    if(local_id == 0) {
        wg_ticket = atomic_fetch_add_explicit(wg_counter, 1, memory_order_acq_rel);
    }
    barrier(CLK_LOCAL_MEM_FENCE);
    group_id = wg_ticket;

    if (group_id == 0) {
        if (local_id == 0) {
            // Allow the other thread in the WG to proceed
            atomic_store_explicit(&wg_flag[local_id], 1, memory_order_release);
        }
        if (local_id == 1) {
            // Wait for the other thread in the WG
            while (atomic_load_explicit(&wg_flag[local_id - 1], memory_order_acquire) == 0);
            // Allow the other WG to proceed
            atomic_store_explicit(&dev_flag[group_id], 1, memory_order_release);
        }
    }

    if (group_id == 1) {
        // Wait for the other WG
        while (atomic_load_explicit(&dev_flag[group_id - 1], memory_order_acquire) == 0);
        if (local_id == 0) {
            // Allow the other thread in the WG to proceed
            atomic_store_explicit(&wg_flag[local_id], 1, memory_order_release);
        }
        if (local_id == 1) {
            // Wait for the other thread in the WG
            while (atomic_load_explicit(&wg_flag[local_id - 1], memory_order_acquire) == 0);
        }
    }
}
