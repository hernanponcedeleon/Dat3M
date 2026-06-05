// Currently, clspv inserts Coherent decorations only if accesses are separated
// by a global control barrier, ignoring release-acquire synchronization.
// To work around this, we manually insert Coherent decoration for variable 'x'
// before upgrading the memory model.

// clspv caslock-sc.cl --cl-std=CL2.0 --inline-entry-points --spv-version=1.6
// spirv-dis a.spv > caslock-sc.spvasm
// Add 'OpDecorate %18 Coherent' (id might be different depending on clspv version)
// spirv-as caslock-sc.spvasm -o a.spv
// spirv-opt --upgrade-memory-model a.spv -o a.spv
// spirv-dis a.spv > caslock-sc.spvasm

void lock(global uint* l) {
    while (atom_cmpxchg(l, 0, 1) == 1) {}
}

void unlock(global uint* l) {
    atom_xchg(l, 0);
}

__kernel void mutex_test(global uint* l, global int* x, global int* A) {
    int a;
    lock(l);
    a = *x;
    *x = a + 1;
    unlock(l);
    A[get_global_id(0)] = a;
}
