// This MP pattern is the core of the decoupled lookback implementation of prefixsum.
// If we statically decide which WG every WG waits for (i.e., using WG ids), then the
// code is not portable (at least under OBE) due to the lack of forward progress.
// If we instead decide dynamically (i.e., using a ticket and an atomic increment)
// the waiting order, then the code is portable wrt OBE (but not wrt HSA).

groupshared uint gid;
RWStructuredBuffer<Atomic<uint32_t>> flag;
RWStructuredBuffer<Atomic<uint32_t>> ticket;

[numthreads(2, 1, 1)]
void Main(uint3 threadID : SV_GroupThreadID, uint3 groupID : SV_GroupID)
{
    uint tid = threadID.x;
    if (tid == 0) {
#ifdef Ticket
        // This version is portable if WGs experience OBE (or FAIR), even if at lower levels the model is UNFAIR
        gid = ticket[0].add(1, MemoryOrder.Relaxed);
#else
        // This version is portable if WGs experience HSA (or FAIR), even if at lower levels the model is UNFAIR
        gid = groupID.x;
#endif
    }
    GroupMemoryBarrierWithGroupSync();
    if (gid == 0 && tid == 0) {
        flag[0].store(1, MemoryOrder.Release);
    }
    if (gid == 1 && tid == 0) {
        while(flag[0].load(MemoryOrder.Acquire) == 0);
    }
}
