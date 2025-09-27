//; @Input: %input = {{0, 1, 3}}
//; @Input: %smax1 = {{0, 0, 0}}
//; @Input: %smax2 = {{0, 0, 0}}
//; @Input: %smax3 = {{0, 0, 0}}
//; @Input: %smin1 = {{0, 0, 0}}
//; @Input: %smin2 = {{0, 0, 0}}
//; @Input: %smin3 = {{0, 0, 0}}
//; @Output: forall (%smax1[0][0] == 1 and %smax1[0][1] == 3 and %smax1[0][2] == 3)
//; @Output: forall (%smax2[0][0] == 1 and %smax2[0][1] == 3 and %smax2[0][2] == 3)
//; @Output: forall (%smax3[0][0] == 3 and %smax3[0][1] == 3 and %smax3[0][2] == 1)
//; @Output: forall (%smin1[0][0] == 0 and %smin1[0][1] == 1 and %smin1[0][2] == 0)
//; @Output: forall (%smin2[0][0] == 0 and %smin2[0][1] == 1 and %smin2[0][2] == 0)
//; @Output: forall (%smin3[0][0] == 1 and %smin3[0][1] == 0 and %smin3[0][2] == 0)
//; @Config: 3, 1, 1

RWStructuredBuffer<int32_t> input;
RWStructuredBuffer<int32_t> smax1;
RWStructuredBuffer<int32_t> smax2;
RWStructuredBuffer<int32_t> smax3;
RWStructuredBuffer<int32_t> smin1;
RWStructuredBuffer<int32_t> smin2;
RWStructuredBuffer<int32_t> smin3;

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
}