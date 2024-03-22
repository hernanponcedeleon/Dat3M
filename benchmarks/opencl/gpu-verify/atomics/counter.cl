//pass
//--local_size=1024 --num_groups=1 --no-inline

kernel void counter (local uint* A)
{
	local int count;
	if (get_local_id(0) == 0)
		count = 0;
	barrier(CLK_LOCAL_MEM_FENCE);
	A[atomic_inc(&count)] = get_local_id(0);
}
