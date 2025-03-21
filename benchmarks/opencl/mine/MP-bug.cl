// clspv MP-bug.cl --cl-std=CL2.0 --inline-entry-points --spv-version=1.6 -o kernel.spv
// spirv-opt --upgrade-memory-model kernel.spv -o kernel-opt.spv
// spirv-dis kernel-opt.spv > MP-bug.spv.dis

__kernel void test(global atomic_uint* flag, global uint* data, global uint* r0) {

    unsigned int group_id = get_group_id(0);
    unsigned int num_groups = get_num_groups(0);

    // We assume a single thread per WG

    // All WGs but the last write data and inform the next WG
    if (group_id != num_groups) {
        // The thread writes its data
        data[group_id] = 1;
        // The WG informs the next WG that data is ready
        atomic_store_explicit(&flag[group_id], 1, memory_order_release);
    }

    // All WGs but the first wait to be informed data is ready, before reading
    if (group_id != 0) {
        // The WG waits the previous WG to be ready
        while (atomic_load_explicit(&flag[group_id - 1], memory_order_acquire) == 1);
        // Thread reads their data
        r0[group_id] = data[group_id - 1];
    }
}
