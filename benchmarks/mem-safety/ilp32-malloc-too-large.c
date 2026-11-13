#include <assert.h>
#include <stddef.h>

/*
    On 32-bit, an allocation of constant size close to 4 GB can never fit into the address space
    next to the program's other objects.

    Expected verdicts:
      default: true  (malloc always returns NULL)
      -DFAIL:  false
*/

extern void *malloc(size_t size);

int g = 7;

int main(void) {
    int *small = malloc(sizeof(int));
    char *huge = malloc(0xFFFFFFF0u);
#ifdef FAIL
    assert(huge != NULL);
#endif
    *small = 42;
    assert(*small == 42 && g == 7);
    return 0;
}
