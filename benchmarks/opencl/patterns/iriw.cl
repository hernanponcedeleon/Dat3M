//; @Input: %x = {{0}}
//; @Input: %y = {{0}}
//; @Input: %r0 = {{0}}
//; @Input: %r1 = {{0}}
//; @Input: %r2 = {{0}}
//; @Input: %r3 = {{0}}
//; @Output: exists (%r0[0][0] == 1 and %r1[0][0] == 0 and %r2[0][0] == 1 and %r3[0][0] == 0)
//; @Config: 4, 1, 1

__kernel void test(global atomic_uint* x, global atomic_uint* y, global uint* r0, global uint* r1, global uint* r2, global uint* r3) {
    if (get_local_id(0) == 0) {
        atomic_store_explicit(x, 1, memory_order_release);
    }
    if (get_local_id(0) == 1) {
        atomic_store_explicit(y, 1, memory_order_release);
    }
    if (get_local_id(0) == 2) {
        *r0 = atomic_load_explicit(x, memory_order_acquire);
        *r1 = atomic_load_explicit(y, memory_order_acquire);
    }
    if (get_local_id(0) == 3) {
        *r2 = atomic_load_explicit(y, memory_order_acquire);
        *r3 = atomic_load_explicit(x, memory_order_acquire);
    }
}
