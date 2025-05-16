#include <assert.h>

typedef struct {
    int a __attribute__ ((aligned (8)));
    int b __attribute__ ((aligned (8)));
} aligned_t;

typedef struct {
    int a;
    int b;
} unaligned_t;

void test(int *r_aligned, int* r_unaligned, aligned_t* aligned, unaligned_t* unaligned) {
    aligned[0].a = 0;
    aligned[0].b = 1;
    aligned[1].a = 2;
    aligned[1].b = 3;

    unaligned[0].a = 4;
    unaligned[0].b = 5;
    unaligned[1].a = 6;
    unaligned[1].b = 7;

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
    assert(r_aligned[2] == 1);
    assert(r_aligned[4] == 2);
    assert(r_aligned[6] == 3);

    assert(r_unaligned[0] == 4);
    assert(r_unaligned[1] == 5);
    assert(r_unaligned[2] == 6);
    assert(r_unaligned[3] == 7);

    return 0;
}
