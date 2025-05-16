#include <assert.h>
#include <stdio.h>

typedef int aligned_sub_t[3] __attribute__((aligned(16)));
typedef aligned_sub_t aligned_t[3] __attribute__((aligned(64)));

typedef int unaligned_sub_t[3];
typedef unaligned_sub_t unaligned_t[3];

aligned_t aligned[3];
unaligned_t unaligned[3];

void test(int *r_aligned, int* r_unaligned) {
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            aligned[0][i][j] = i * 3 + j;
            aligned[1][i][j] = 9 + i * 3 + j;
            unaligned[0][i][j] = 18 + i * 3 + j;
            unaligned[0][i][j] = 27 + i * 3 + j;
        }
    }
    for (int i = 0; i < 64; i++) {
        r_aligned[i] = *(((int*) aligned) + i);
        r_unaligned[i] = *(((int*) unaligned) + i);
    }
}

int main() {
    int r_aligned[64];
    int r_unaligned[64];

    test(r_aligned, r_unaligned);

    for (int i = 0; i < 64; i++)
        printf("%d ", r_aligned[i]);
    printf("\n");

    for (int i = 0; i < 64; i++)
        printf("%d ", r_unaligned[i]);
    printf("\n");
/*
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
*/
    return 0;
}
