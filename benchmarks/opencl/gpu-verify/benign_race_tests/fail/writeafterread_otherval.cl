//xfail:NOT_ALL_VERIFIED
//--local_size=64 --num_groups=1 --equality-abstraction --no-inline
//kernel.cl: error: possible read-write race on

#define tid get_local_id(0)

__kernel void foo(__local int* A, __local int* B) {
  int v;

  B[tid] = A[0];
  A[0] = 5;
}
