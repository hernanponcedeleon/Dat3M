#include <assert.h>

typedef int aligned_t __attribute__((vector_size(3 * sizeof(int))));
typedef int unaligned_t[3];

aligned_t aligned[3];
unaligned_t unaligned[3];

void test(int *r_aligned, int* r_unaligned) {
    aligned[0][0] = 0;
    aligned[0][1] = 1;
    aligned[0][2] = 2;

    aligned[1][0] = 3;
    aligned[1][1] = 4;
    aligned[1][2] = 5;

    unaligned[0][0] = 6;
    unaligned[0][1] = 7;
    unaligned[0][2] = 8;

    unaligned[1][0] = 9;
    unaligned[1][1] = 10;
    unaligned[1][2] = 11;

    for (int i = 0; i < 8; i++) {
        r_aligned[i] = *(((int*) aligned) + i);
        r_unaligned[i] = *(((int*) unaligned) + i);
    }
}

int main() {
    int r_aligned[8];
    int r_unaligned[8];

    test(r_aligned, r_unaligned);

    assert(r_aligned[0] == 0);
    assert(r_aligned[1] == 1);
    assert(r_aligned[2] == 2);
    assert(r_aligned[4] == 3);
    assert(r_aligned[5] == 4);
    assert(r_aligned[6] == 5);

    assert(r_unaligned[0] == 6);
    assert(r_unaligned[1] == 7);
    assert(r_unaligned[2] == 8);
    assert(r_unaligned[3] == 9);
    assert(r_unaligned[4] == 10);
    assert(r_unaligned[5] == 11);

    return 0;
}
