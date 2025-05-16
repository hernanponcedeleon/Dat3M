#include <assert.h>

typedef struct __attribute__ ((aligned (32))) {
    int a;
    int b;
    int c;
    int d;
    int e;
} aligned_t;

typedef struct {
    int a;
    int b;
    int c;
    int d;
    int e;
} unaligned_t;

void test(int *r_aligned, int* r_unaligned, aligned_t* aligned, unaligned_t* unaligned) {
    aligned[0].a = 0;
    aligned[0].b = 1;
    aligned[0].c = 2;
    aligned[0].d = 3;
    aligned[0].e = 4;

    aligned[1].a = 5;
    aligned[1].b = 6;
    aligned[1].c = 7;
    aligned[1].d = 8;
    aligned[1].e = 9;

    unaligned[0].a = 10;
    unaligned[0].b = 11;
    unaligned[0].c = 12;
    unaligned[0].d = 13;
    unaligned[0].e = 14;

    unaligned[1].a = 15;
    unaligned[1].b = 16;
    unaligned[1].c = 17;
    unaligned[1].d = 18;
    unaligned[1].e = 19;

    for (int i = 0; i < 16; i++) {
        r_aligned[i] = *(((int*) aligned) + i);
        r_unaligned[i] = *(((int*) unaligned) + i);
    }
}

int main() {
    int r_aligned[16];
    int r_unaligned[16];
    aligned_t aligned[3];
    unaligned_t unaligned[3];

    test(r_aligned, r_unaligned, aligned, unaligned);

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
