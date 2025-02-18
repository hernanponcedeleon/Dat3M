// clspv caslock-cs.cl --cl-std=CL1.0 --inline-entry-points --spv-version=1.6
// spirv-dis a.spv

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
