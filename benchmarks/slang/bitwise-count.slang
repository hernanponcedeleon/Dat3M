//; @Input: %input = {{0, 1, 3}}
//; @Input: %output1 = {{0, 0, 0}}
//; @Input: %output2 = {{0, 0, 0}}
//; @Input: %output3 = {{0, 0, 0}}
//; @Output: forall (%output1[0][0] == 0 and %output1[0][1] == 1 and %output1[0][2] == 2)
//; @Output: forall (%output2[0][0] == 0 and %output2[0][1] == 1 and %output2[0][2] == 2)
//; @Output: forall (%output3[0][0] == 1 and %output3[0][1] == 2 and %output3[0][2] == 0)
//; @Config: 3, 1, 1

RWStructuredBuffer<uint32_t> input;
RWStructuredBuffer<uint32_t> output1;
RWStructuredBuffer<uint32_t> output2;
RWStructuredBuffer<uint32_t> output3;

[numthreads(3, 1, 1)]
void Main(uint3 threadID : SV_GroupThreadID)
{
    uint tid = threadID.x;

    uint32_t in = input[tid];
    uint32_t count = countbits(in);
    output1[tid] = count;

    uint2 vin = uint2(input[tid], input[(tid+1) % 3]);
    uint2 vcount = countbits(vin);
    output2[tid] = vcount.x;
    output3[tid] = vcount.y;
}