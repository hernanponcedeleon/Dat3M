//; @Input: %input = {{0, 1, 3}}
//; @Input: %arshift1 = {{0, 0, 0}}
//; @Input: %arshift2 = {{0, 0, 0}}
//; @Input: %arshift3 = {{0, 0, 0}}
//; @Input: %rshift1 = {{0, 0, 0}}
//; @Input: %rshift2 = {{0, 0, 0}}
//; @Input: %rshift3 = {{0, 0, 0}}
//; @Input: %lshift1 = {{0, 0, 0}}
//; @Input: %lshift2 = {{0, 0, 0}}
//; @Input: %lshift3 = {{0, 0, 0}}
//; @Output: forall (%arshift1[0][0] == 0 and %arshift1[0][1] == 0 and %arshift1[0][2] == 1)
//; @Output: forall (%arshift2[0][0] == 0 and %arshift2[0][1] == 0 and %arshift2[0][2] == 1)
//; @Output: forall (%arshift3[0][0] == 0 and %arshift3[0][1] == 1 and %arshift3[0][2] == 0)
//; @Output: forall (%rshift1[0][0] == 0 and %rshift1[0][1] == 0 and %rshift1[0][2] == 1)
//; @Output: forall (%rshift2[0][0] == 0 and %rshift2[0][1] == 0 and %rshift2[0][2] == 1)
//; @Output: forall (%rshift3[0][0] == 0 and %rshift3[0][1] == 1 and %rshift3[0][2] == 0)
//; @Output: forall (%lshift1[0][0] == 0 and %lshift1[0][1] == 2 and %lshift1[0][2] == 6)
//; @Output: forall (%lshift2[0][0] == 0 and %lshift2[0][1] == 2 and %lshift2[0][2] == 6)
//; @Output: forall (%lshift3[0][0] == 2 and %lshift3[0][1] == 6 and %lshift3[0][2] == 0)
//; @Config: 3, 1, 1

RWStructuredBuffer<int32_t> input;
RWStructuredBuffer<int32_t> arshift1;
RWStructuredBuffer<int32_t> arshift2;
RWStructuredBuffer<int32_t> arshift3;
RWStructuredBuffer<int32_t> rshift1;
RWStructuredBuffer<int32_t> rshift2;
RWStructuredBuffer<int32_t> rshift3;
RWStructuredBuffer<int32_t> lshift1;
RWStructuredBuffer<int32_t> lshift2;
RWStructuredBuffer<int32_t> lshift3;

[numthreads(3, 1, 1)]
void Main(uint3 threadID : SV_GroupThreadID)
{
    uint tid = threadID.x;
    int32_t in = input[tid];
    int2 vin = int2(input[tid], input[(tid+1) % 3]);
    // Casts required for logical right shift
    uint32_t uin = (uint32_t)input[tid];
    uint2 vuin = uint2((uint32_t)input[tid], (uint32_t)input[(tid+1) % 3]);

    // ARSHIFT
    int32_t arshift = in >> 1;
    arshift1[tid] = arshift;
    int2 varshift = vin >> 1;
    arshift2[tid] = varshift.x;
    arshift3[tid] = varshift.y;

    // RSHIFT
    uint32_t rshift = uin >> 1;
    rshift1[tid] = rshift;
    uint2 vrshift = vuin >> 1;
    rshift2[tid] = vrshift.x;
    rshift3[tid] = vrshift.y;

    // LSHIFT
    uint32_t lshift = in << 1;
    lshift1[tid] = lshift;
    int2 vlshift = vin << 1;
    lshift2[tid] = vlshift.x;
    lshift3[tid] = vlshift.y;
}
