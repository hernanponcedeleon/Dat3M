#include <stdio.h>
#include <assert.h>
#include <string.h>

char src[5] = "Hello";
char dest[5];

int main () {

#ifdef FAIL
    int bytesToCopy = sizeof(src) - sizeof(char);
#else
    int bytesToCopy = sizeof(src);
#endif
    memcpy(dest, src, bytesToCopy);
    for(int i = 0; i < sizeof(src); i++) {
        assert(dest[i] == src[i]);
    }

    return(0);
}