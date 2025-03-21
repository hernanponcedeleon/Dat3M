// clspv MP-bug.cl --cl-std=CL2.0 --inline-entry-points --spv-version=1.6 -o kernel.spv
// spirv-opt --upgrade-memory-model kernel.spv -o kernel-opt.spv
// spirv-dis kernel-opt.spv > MP-bug.spv.dis

__kernel void test(global atomic_uint* flag, global uint* data, global uint* r0) {

    unsigned int group_id = get_group_id(0);
    unsigned int num_groups = get_num_groups(0);

    if (group_id != 0) {
        // group 1
        data[group_id] = 1; // data[1]
        atomic_store_explicit(&flag[group_id], 1, memory_order_release); // flag[1]
    }

    // All WGs but the first wait to be informed data is ready, before reading
    if (group_id != num_groups - 1) {
        // group 0
        while (atomic_load_explicit(&flag[num_groups - 1], memory_order_acquire) == 1); // flag[1]
        // Thread reads their data
        r0[num_groups - 1] = data[num_groups - 1]; // flag[1], r0[1]
    }
}
