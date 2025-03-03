// clang -x cl -cl-std=CL2.0 -target spir-unknown-unknown -cl-opt-disable -emit-llvm -c alignment1.cl -o a.bc
// llvm-spirv a.bc -o a.spv
// spirv-dis a.spv > alignment1.spvasm

__kernel void test(global uint *x)
{
    local uint3 data[2];

    data[0].x = 0;
    data[0].y = 1;
    data[0].z = 2;

    data[1].x = 3;
    data[1].y = 4;
    data[1].z = 5;

    for (int i = 0; i < 8; i++)
    {
        x[i] = *(((uint*)data) + i);
    }
}