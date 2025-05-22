// clang -x cl -cl-std=CL2.0 -target spir-unknown-unknown -fno-discard-value-names -cl-opt-disable -emit-llvm -c alignment5-struct-local.cl -o a.bc
// llvm-spirv a.bc -o a.spv
// spirv-dis a.spv > alignment5-struct-local.spvasm

// clspv -O0 alignment5-struct-local.cl --cl-std=CL2.0 --inline-entry-points --spv-version=1.6
// spirv-opt --upgrade-memory-model -o a.opt.spv a.spv
// spirv-dis a.opt.spv > alignment5-struct-local.spvasm

typedef struct {
    char a __attribute__ ((aligned (4)));
    char b[4];
} aligned_t;

typedef struct {
    char a;
    char b[4];
} unaligned_t;

__kernel void test(global char *r_aligned, global char* r_unaligned) {
    local aligned_t aligned[3];
    local unaligned_t unaligned[3];

    aligned[0].a = 0;
    aligned[0].b[0] = 1;
    aligned[0].b[1] = 2;
    aligned[0].b[2] = 3;
    aligned[0].b[3] = 4;

    aligned[1].a = 5;
    aligned[1].b[0] = 6;
    aligned[1].b[1] = 7;
    aligned[1].b[2] = 8;
    aligned[1].b[3] = 9;

    unaligned[0].a = 10;
    unaligned[0].b[0] = 11;
    unaligned[0].b[1] = 12;
    unaligned[0].b[2] = 13;
    unaligned[0].b[3] = 14;

    unaligned[1].a = 15;
    unaligned[1].b[0] = 16;
    unaligned[1].b[1] = 17;
    unaligned[1].b[2] = 18;
    unaligned[1].b[3] = 19;

    for (int i = 0; i < 16; i++) {
        r_aligned[i] = *(((char*) aligned) + i);
        r_unaligned[i] = *(((char*) unaligned) + i);
    }
}
