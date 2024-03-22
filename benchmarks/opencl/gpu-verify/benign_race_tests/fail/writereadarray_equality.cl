//xfail:NOT_ALL_VERIFIED
//--local_size=2 --num_groups=1 --equality-abstraction --no-inline
//kernel.cl: error: possible write-read race on

void foo(int);

#define tid get_local_id(0)

__kernel void example(__local int* A) {
 A[tid] = 0;
 foo(A[tid + 1]);
}
