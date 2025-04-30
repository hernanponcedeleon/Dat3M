// clang -x cl -cl-std=CL2.0 -target spir-unknown-unknown -cl-opt-disable -emit-llvm -c alignment7.cl -o a.bc
// llvm-spirv a.bc -o a.spv
// spirv-dis a.spv > alignment7.spvasm

struct struct1 {
    int a;    // 4 bytes, aligned to 4
    char b;   // 1 byte
}__attribute__ ((aligned (16)));

struct struct2 {
    char b;   // 1 byte
    int a;    // 4 bytes, aligned to 4
};

global struct struct1 s1;
global struct struct2 s2;

__kernel void manual_vs_struct(__global uchar *out, __global struct struct1 *s1, __global struct struct2 *s2)
{
    s1->a = 0;
    s1->b = 1;
    s2->a = 2;
    s2->b = 3;
    *((int *)(&s1->a + 1)) = 22;
    *((int *)(&s2->a + 1)) = 33;

    out[0] = s1->a;
    out[1] = s1->b;
    out[2] = s2->a;
    out[3] = s2->b;
}