// clang -x cl -cl-std=CL2.0 -target spir-unknown-unknown -fno-discard-value-names -cl-opt-disable -emit-llvm -c alignment1-struct-local.cl -o a.bc
// llvm-spirv a.bc -o a.spv
// spirv-dis a.spv > alignment1-struct-local.spvasm

// clspv -O0 alignment1-struct-local.cl --cl-std=CL2.0 --inline-entry-points --spv-version=1.6
// spirv-opt --upgrade-memory-model -o a.opt.spv a.spv
// spirv-dis a.opt.spv > alignment1-struct-local.spvasm

typedef struct __attribute__ ((aligned (16))) {
    int x;
    int y;
    int z;
} aligned_t;

typedef struct {
    int x;
    int y;
    int z;
} unaligned_t;

__kernel void test(global int *r_aligned, global int* r_unaligned) {
    local aligned_t aligned[3];
    local unaligned_t unaligned[3];

    aligned[0].x = 0;
    aligned[0].y = 1;
    aligned[0].z = 2;

    aligned[1].x = 3;
    aligned[1].y = 4;
    aligned[1].z = 5;

    unaligned[0].x = 6;
    unaligned[0].y = 7;
    unaligned[0].z = 8;

    unaligned[1].x = 9;
    unaligned[1].y = 10;
    unaligned[1].z = 11;

    for (int i = 0; i < 8; i++) {
        r_aligned[i] = *(((int*) aligned) + i);
        r_unaligned[i] = *(((int*) unaligned) + i);
    }
}
