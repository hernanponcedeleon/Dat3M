#include <assert.h>
#include <stddef.h>
extern void *malloc(size_t size);
int g = 7;
int main(void) {
    int *small = malloc(sizeof(int));
    char *huge = malloc(0xFFFFFFF0u);
    if (huge != NULL) { return 0; }
    *small = 42;
    assert(g == 7);
    return 0;
}
