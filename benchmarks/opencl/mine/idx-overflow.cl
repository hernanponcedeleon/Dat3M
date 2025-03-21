// clspv idx-overflow.cl --cl-std=CL2.0 --inline-entry-points --spv-version=1.6 -o kernel.spv
// spirv-opt --upgrade-memory-model kernel.spv -o kernel-opt.spv
// spirv-dis kernel-opt.spv > idx-overflow.spv.dis

// clang -c -target spir -cl-std=CL2.0 -O0 -emit-llvm -o kernel.bc idx-overflow.cl
// llvm-spirv kernel.bc -o kernel.spv
// spirv-dis kernel.spv -o idx-overflow-opencl.spv.dis

__kernel void test(global uint* x, global uint* y) {

    unsigned int group_id = get_group_id(0);
    unsigned int num_groups = get_num_groups(0);

    if (group_id != num_groups - 1) {
        x[group_id] = 1;        // x[0] = 1
        y[num_groups - 1] = 2;  // y[1] = 2
    }

    if (group_id != 0) {
       x[num_groups - 1] = 3;   // x[1] = 3
       y[group_id - 1] = 4;     // y[0] = 4
    }
}
