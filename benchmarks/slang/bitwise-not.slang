//; @Input: %input = {{0, 1, 3}}
//; @Input: %output1 = {{0, 0, 0}}
//; @Input: %output2 = {{0, 0, 0}}
//; @Input: %output3 = {{0, 0, 0}}
//; @Output: forall (%output1[0][0] == 255 and %output1[0][1] == 254 and %output1[0][2] == 252)
//; @Output: forall (%output2[0][0] == 4294967295 and %output2[0][1] == 4294967294 and %output2[0][2] == 4294967292)
//; @Output: forall (%output3[0][0] == 4294967294 and %output3[0][1] == 4294967292 and %output3[0][2] == 4294967295)
//; @Config: 3, 1, 1

RWStructuredBuffer<uint8_t> input;
RWStructuredBuffer<uint8_t> output1;
RWStructuredBuffer<uint32_t> output2;
RWStructuredBuffer<uint32_t> output3;

[numthreads(3, 1, 1)]
void Main(uint3 threadID : SV_GroupThreadID, uint3 groupID : SV_GroupID)
{
    uint tid = threadID.x;

    uint8_t in = input[tid];
    uint8_t not = ~in;
    output1[tid] = not;

    int2 vin = int2(input[tid], input[(tid+1) % 3]);
    int2 vnot = ~vin;
    output2[tid] = vnot.x;
    output3[tid] = vnot.y;
}
