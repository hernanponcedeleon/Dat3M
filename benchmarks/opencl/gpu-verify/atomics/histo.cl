//pass
//--local_size=1024 --num_groups=1 --no-inline

__kernel void atomic (__local int* A,
                      __local int* B)
{
	int tid = get_local_id(0);
	int t = A[tid];
	atomic_inc(B + t);
}
