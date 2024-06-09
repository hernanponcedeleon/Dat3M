#include <assert.h>
#include <stddef.h>

#ifdef __STDC_LIB_EXT1__
    #define __STDC_WANT_LIB_EXT1__ 1
    #include <string.h>
#else
    #define rsize_t size_t
    #define errno_t int
    extern errno_t memcpy_s( void *restrict dest, rsize_t destsz, const void *restrict src, rsize_t count );
#endif

int main()
{
    int a[4] = { 1, 2, 3, 4 };
    int b[3] = { 5, 6, 7};

    int ret;

    // NULL dest
    ret = memcpy_s(NULL, 3*sizeof(int), a, 3*sizeof(int));
    assert(ret > 0);

    // NULL src
    ret = memcpy_s(b, 3*sizeof(int), NULL, 3*sizeof(int));
    assert(ret > 0);
    assert(b[0] == 0);
    assert(b[1] == 0);
    assert(b[2] == 0);
    b[0] = 5;
    b[1] = 6;
    b[2] = 7;

    // count > destsz
    ret = memcpy_s(b, 2*sizeof(int), a, 4*sizeof(int));
    assert(ret > 0);
    assert(b[0] == 0);
    assert(b[1] == 0);
    // only [dest, dest+destsz) is zeroed
    assert(b[2] == 7);
    b[0] = 5;
    b[1] = 6;

    // Overlapping src and dest
    ret = memcpy_s(b, 3*sizeof(int), b, 3*sizeof(int));
    assert(ret > 0);
    assert(b[0] == 0);
    assert(b[1] == 0);
    assert(b[2] == 0);
    b[0] = 5;
    b[1] = 6;
    b[2] = 7;

    // Success
    ret = memcpy_s(b, 3*sizeof(int), a, 3*sizeof(int));
    assert(ret == 0);
    assert(b[0] == 1);
    assert(b[1] == 2);
    assert(b[2] == 3);

	return 0;
}
