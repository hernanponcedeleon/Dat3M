//xfail:NOT_ALL_VERIFIED
//--local_size=1024 --num_groups=1 --no-inline
//kernel.cl: error: possible atomic-write race on A\[12\]:
//Write by work item 12 with local id 12 in work group 0
//Atomic by work item \d+ with local id \d+ in work group 0

kernel void pointers (local int* A, local int* B, int c)
{
	local int* p;
	uint tid = get_local_id(0);
	if (c)
		p = B + 3;
	else
		p = A + 12;
	A[tid] = atomic_inc(p);
}
