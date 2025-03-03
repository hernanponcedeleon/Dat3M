// clang -x cl -cl-std=CL2.0 -target spir-unknown-unknown -cl-opt-disable -emit-llvm -c alignment10.cl -o a.bc
// llvm-spirv a.bc -o a.spv
// spirv-dis a.spv > alignment10.spvasm

struct struct1 {
    unsigned int a[3]__attribute__ ((aligned (16)));
    unsigned int b[3]__attribute__ ((aligned (16)));
};

struct struct2 {
    unsigned int a[3];
    unsigned int b[3];
};

__kernel void test(global uint *x)
{
    local struct struct1 s1;
    local struct struct2 s2;

    *(((uint*)s1.a[0]) + 4) = 1;
    *(((uint*)s2.a[0]) + 3) = 2;

    x[0] = s1.b[0];
    x[1] = s2.b[0];

}