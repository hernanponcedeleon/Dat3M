#include <stdio.h>
#include <assert.h>
#include <string.h>

int src[5] = {0,1,2,3,4};
int dest[5];

int main () {

#ifdef FAIL
    int bytesToCopy = sizeof(src) - sizeof(int);
#else
    int bytesToCopy = sizeof(src);
#endif
    memcpy(dest, src, bytesToCopy);
    for(int i = 0; i < sizeof(src); i++) {
        assert(dest[i] == src[i]);
    }

    return(0);
}