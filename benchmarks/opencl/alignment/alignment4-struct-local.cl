// clang -x cl -cl-std=CL2.0 -target spir-unknown-unknown -fno-discard-value-names -cl-opt-disable -emit-llvm -c alignment4-struct-local.cl -o a.bc
// llvm-spirv a.bc -o a.spv
// spirv-dis a.spv > alignment4-struct-local.spvasm

// clspv -O0 alignment4-struct-local.cl --cl-std=CL2.0 --inline-entry-points --spv-version=1.6
// spirv-opt --upgrade-memory-model -o a.opt.spv a.spv
// spirv-dis a.opt.spv > alignment4-struct-local.spvasm

typedef struct {
    int a __attribute__ ((aligned (8)));
    int b __attribute__ ((aligned (8)));
    int c __attribute__ ((aligned (16)));
    int d __attribute__ ((aligned (16)));
} aligned_t;

typedef struct {
    int a;
    int b;
    int c;
    int d;
} unaligned_t;

__kernel void test(global int *r_aligned, global int* r_unaligned) {
    local aligned_t aligned[3];
    local unaligned_t unaligned[3];

    aligned[0].a = 0;
    aligned[0].b = 1;
    aligned[0].c = 2;
    aligned[0].d = 3;

    aligned[1].a = 4;
    aligned[1].b = 5;
    aligned[1].c = 6;
    aligned[1].d = 7;

    unaligned[0].a = 8;
    unaligned[0].b = 9;
    unaligned[0].c = 10;
    unaligned[0].d = 11;

    unaligned[1].a = 12;
    unaligned[1].b = 13;
    unaligned[1].c = 14;
    unaligned[1].d = 15;

    for (int i = 0; i < 24; i++) {
        r_aligned[i] = *(((int*) aligned) + i);
        r_unaligned[i] = *(((int*) unaligned) + i);
    }
}
