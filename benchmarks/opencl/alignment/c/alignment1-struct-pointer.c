#include <assert.h>

typedef struct __attribute__ ((aligned (16))) {
    int x;
    int y;
    int z;
} aligned_t;

typedef struct {
    int x;
    int y;
    int z;
} unaligned_t;

void test(int *r_aligned, int* r_unaligned, aligned_t* aligned, unaligned_t* unaligned) {
    aligned[0].x = 0;
    aligned[0].y = 1;
    aligned[0].z = 2;

    aligned[1].x = 3;
    aligned[1].y = 4;
    aligned[1].z = 5;

    unaligned[0].x = 6;
    unaligned[0].y = 7;
    unaligned[0].z = 8;

    unaligned[1].x = 9;
    unaligned[1].y = 10;
    unaligned[1].z = 11;

    for (int i = 0; i < 8; i++) {
        r_aligned[i] = *(((int*) aligned) + i);
        r_unaligned[i] = *(((int*) unaligned) + i);
    }
}

int main() {
    int r_aligned[8];
    int r_unaligned[8];
    aligned_t aligned[3];
    unaligned_t unaligned[3];

    test(r_aligned, r_unaligned, aligned, unaligned);

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
