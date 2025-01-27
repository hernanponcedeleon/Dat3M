#include <assert.h>

typedef struct {
    int __a;
} __attribute__((aligned(128))) A;

int main()
{
    A a;
    assert(&a >= 128);
    return 0;
}
