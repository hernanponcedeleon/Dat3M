// clang -x cl -cl-std=CL2.0 -target spir-unknown-unknown -fno-discard-value-names -cl-opt-disable -emit-llvm -c alignment1-array-local.cl -o a.bc
// llvm-spirv a.bc -o a.spv
// spirv-dis a.spv > alignment1-array-local.spvasm

// clspv -O0 alignment1-array-local.cl --cl-std=CL2.0 --inline-entry-points --spv-version=1.6
// spirv-opt --upgrade-memory-model -o a.opt.spv a.spv
// spirv-dis a.opt.spv > alignment1-array-local.spvasm

typedef int aligned_t __attribute__((vector_size(3 * sizeof(int))));
typedef int unaligned_t[3];

__kernel void test(global int *r_aligned, global int* r_unaligned) {
    local aligned_t aligned[3];
    local unaligned_t unaligned[3];

    aligned[0][0] = 0;
    aligned[0][1] = 1;
    aligned[0][2] = 2;

    aligned[1][0] = 3;
    aligned[1][1] = 4;
    aligned[1][2] = 5;

    unaligned[0][0] = 6;
    unaligned[0][1] = 7;
    unaligned[0][2] = 8;

    unaligned[1][0] = 9;
    unaligned[1][1] = 10;
    unaligned[1][2] = 11;

    for (int i = 0; i < 8; i++) {
        r_aligned[i] = *(((int*) aligned) + i);
        r_unaligned[i] = *(((int*) unaligned) + i);
    }
}
