//; @Input: %input = {{0, -5, 3}}
//; @Input: %smax1 = {{0, 0, 0}}
//; @Input: %smax2 = {{0, 0, 0}}
//; @Input: %smax3 = {{0, 0, 0}}
//; @Input: %smin1 = {{0, 0, 0}}
//; @Input: %smin2 = {{0, 0, 0}}
//; @Input: %smin3 = {{0, 0, 0}}
//; @Input: %umax1 = {{0, 0, 0}}
//; @Input: %umax2 = {{0, 0, 0}}
//; @Input: %umax3 = {{0, 0, 0}}
//; @Input: %umin1 = {{0, 0, 0}}
//; @Input: %umin2 = {{0, 0, 0}}
//; @Input: %umin3 = {{0, 0, 0}}
//; @Output: forall (%smax1[0][0] == 0 and %smax1[0][1] == 3 and %smax1[0][2] == 3)
//; @Output: forall (%smax2[0][0] == 0 and %smax2[0][1] == 3 and %smax2[0][2] == 3)
//; @Output: forall (%smax3[0][0] == 3 and %smax3[0][1] == 3 and %smax3[0][2] == 0)
//; @Output: forall (%smin1[0][0] == -5 and %smin1[0][1] == -5 and %smin1[0][2] == 0)
//; @Output: forall (%smin2[0][0] == -5 and %smin2[0][1] == -5 and %smin2[0][2] == 0)
//; @Output: forall (%smin3[0][0] == -5 and %smin3[0][1] == 0 and %smin3[0][2] == -5)
//; @Output: forall (%umax1[0][0] == 4294967291 and %umax1[0][1] == 4294967291 and %umax1[0][2] == 3)
//; @Output: forall (%umax2[0][0] == 4294967291 and %umax2[0][1] == 4294967291 and %umax2[0][2] == 3)
//; @Output: forall (%umax3[0][0] == 4294967291 and %umax3[0][1] == 3 and %umax3[0][2] == 4294967291)
//; @Output: forall (%umin1[0][0] == 0 and %umin1[0][1] == 3 and %umin1[0][2] == 0)
//; @Output: forall (%umin2[0][0] == 0 and %umin2[0][1] == 3 and %umin2[0][2] == 0)
//; @Output: forall (%umin3[0][0] == 3 and %umin3[0][1] == 0 and %umin3[0][2] == 0)
//; @Config: 3, 1, 1

RWStructuredBuffer<int32_t> input;
// Signed variants
RWStructuredBuffer<int32_t> smax1;
RWStructuredBuffer<int32_t> smax2;
RWStructuredBuffer<int32_t> smax3;
RWStructuredBuffer<int32_t> smin1;
RWStructuredBuffer<int32_t> smin2;
RWStructuredBuffer<int32_t> smin3;
// Unsigned variants
RWStructuredBuffer<uint32_t> umax1;
RWStructuredBuffer<uint32_t> umax2;
RWStructuredBuffer<uint32_t> umax3;
RWStructuredBuffer<uint32_t> umin1;
RWStructuredBuffer<uint32_t> umin2;
RWStructuredBuffer<uint32_t> umin3;

[numthreads(3, 1, 1)]
void Main(uint3 threadID : SV_GroupThreadID)
{
    int tid = threadID.x;

    int32_t in1 = input[tid];
    int32_t in2 = input[(tid+1) % 3];
    int2 vin1 = int2(input[tid], input[(tid+1) % 3]);
    int2 vin2 = int2(input[(tid+1) % 3], input[(tid+2) % 3]);

    smax1[tid] = max(in1, in2);
    smax2[tid] = max(vin1, vin2).x;
    smax3[tid] = max(vin1, vin2).y;

    smin1[tid] = min(in1, in2);
    smin2[tid] = min(vin1, vin2).x;
    smin3[tid] = min(vin1, vin2).y;

    uint32_t uin1 = input[tid];
    uint32_t uin2 = input[(tid+1) % 3];
    uint2 vuin1 = uint2(input[tid], input[(tid+1) % 3]);
    uint2 vuin2 = uint2(input[(tid+1) % 3], input[(tid+2) % 3]);

    umax1[tid] = max(uin1, uin2);
    umax2[tid] = max(vuin1, vuin2).x;
    umax3[tid] = max(vuin1, vuin2).y;

    umin1[tid] = min(uin1, uin2);
    umin2[tid] = min(vuin1, vuin2).x;
    umin3[tid] = min(vuin1, vuin2).y;
}