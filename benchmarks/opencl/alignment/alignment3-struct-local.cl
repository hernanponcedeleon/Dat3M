// clang -x cl -cl-std=CL2.0 -target spir-unknown-unknown -fno-discard-value-names -cl-opt-disable -emit-llvm -c alignment3-struct-local.cl -o a.bc
// llvm-spirv a.bc -o a.spv
// spirv-dis a.spv > alignment3-struct-local.spvasm

// clspv -O0 alignment3-struct-local.cl --cl-std=CL2.0 --inline-entry-points --spv-version=1.6
// spirv-opt --upgrade-memory-model -o a.opt.spv a.spv
// spirv-dis a.opt.spv > alignment3-struct-local.spvasm

typedef struct {
    int a __attribute__ ((aligned (8)));
    int b __attribute__ ((aligned (8)));
} aligned_t;

typedef struct {
    int a;
    int b;
} unaligned_t;

__kernel void test(global int *r_aligned, global int* r_unaligned) {
    local aligned_t aligned[3];
    local unaligned_t unaligned[3];

    aligned[0].a = 0;
    aligned[0].b = 1;
    aligned[1].a = 2;
    aligned[1].b = 3;

    unaligned[0].a = 4;
    unaligned[0].b = 5;
    unaligned[1].a = 6;
    unaligned[1].b = 7;

    for (int i = 0; i < 8; i++) {
        r_aligned[i] = *(((int*) aligned) + i);
        r_unaligned[i] = *(((int*) unaligned) + i);
    }
}
