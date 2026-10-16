//; @Input: %l = {{0}}
//; @Input: %x = {{0}}
//; @Input: %A = {{-1, -1}}
//; @Output: forall (%A[0][0] == -1 or %A[0][1] == -1 or %A[0][0] != %A[0][1])
//; @Config: 2, 1, 1

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
