//xfail:NOT_ALL_VERIFIED
//--local_size=1024 --num_groups=1 --no-inline
//error: possible read-atomic race

__kernel void atomic (__local int* A)
{
    volatile int x;
    x = A[get_local_id(0)];
    atomic_inc(A);
}
