#include <assert.h>

typedef int aligned_t __attribute__((vector_size(5 * sizeof(int))));
typedef int unaligned_t[5];

aligned_t aligned[3];
unaligned_t unaligned[3];

void test(int *r_aligned, int* r_unaligned) {
    aligned[0][0] = 0;
    aligned[0][1] = 1;
    aligned[0][2] = 2;
    aligned[0][3] = 3;
    aligned[0][4] = 4;

    aligned[1][0] = 5;
    aligned[1][1] = 6;
    aligned[1][2] = 7;
    aligned[1][3] = 8;
    aligned[1][4] = 9;

    unaligned[0][0] = 10;
    unaligned[0][1] = 11;
    unaligned[0][2] = 12;
    unaligned[0][3] = 13;
    unaligned[0][4] = 14;

    unaligned[1][0] = 15;
    unaligned[1][1] = 16;
    unaligned[1][2] = 17;
    unaligned[1][3] = 18;
    unaligned[1][4] = 19;

    for (int i = 0; i < 16; i++) {
        r_aligned[i] = *(((int*) aligned) + i);
        r_unaligned[i] = *(((int*) unaligned) + i);
    }
}

int main() {
    int r_aligned[16];
    int r_unaligned[16];

    test(r_aligned, r_unaligned);

    assert(r_aligned[0] == 0);
    assert(r_aligned[1] == 1);
    assert(r_aligned[2] == 2);
    assert(r_aligned[3] == 3);
    assert(r_aligned[4] == 4);
    assert(r_aligned[8] == 5);
    assert(r_aligned[9] == 6);
    assert(r_aligned[10] == 7);
    assert(r_aligned[11] == 8);
    assert(r_aligned[12] == 9);

    assert(r_unaligned[0] == 10);
    assert(r_unaligned[1] == 11);
    assert(r_unaligned[2] == 12);
    assert(r_unaligned[3] == 13);
    assert(r_unaligned[4] == 14);
    assert(r_unaligned[5] == 15);
    assert(r_unaligned[6] == 16);
    assert(r_unaligned[7] == 17);
    assert(r_unaligned[8] == 18);
    assert(r_unaligned[9] == 19);

    return 0;
}
