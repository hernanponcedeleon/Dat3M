static void lock(global uint* l) {
    while (atom_cmpxchg(l, 0, 1) == 1) {}
}

static void unlock(global uint* l) {
    atom_xchg(l, 0);
}

__kernel void mutex_test(global uint* l, global int* x, global int* A) {
    int a;
    lock(l);
    a = *x;
    *x = a + 1;
    unlock(l);
} 
