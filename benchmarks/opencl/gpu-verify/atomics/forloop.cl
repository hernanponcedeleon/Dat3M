//xfail:NOT_ALL_VERIFIED
//--local_size=1024 --num_groups=1 --no-inline
//B\[tid\] = v;
//v = atomic_add\(B\+i,v\);

// This is to test whether GPUVerify can correctly report the relevant atomic line
__kernel void blarp (global int* A, int x)
{
	int v=0;
	int i;

	uint tid = get_global_id(0);

	for (i = 0; i < x; i++)
	{
		v = atomic_add(A+i,v);
	}

	A[tid] = v;
}
