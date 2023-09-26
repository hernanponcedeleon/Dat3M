#include <assert.h>
#include <stdlib.h>
int __VERIFIER_nondet_int(void);
typedef unsigned short u16;
typedef unsigned int u32;

u16 get_mistyped(u16* array)
{
    return array[0];
}

u16 get_offset(u16* array)
{
    return array[1];
}

u32 get_misaligned(u16* array)
{
    u32* interpreted = (u32*)((void*)(array + 1));
    return *interpreted;
}

int main()
{
    u32* array = (u32*) malloc(2 * sizeof(u32));
    u32 value = __VERIFIER_nondet_int();
    array[1] = array[0] = value;
    u16 easy = get_mistyped((u16*)((void*)array));
    assert(easy == (value & 0xffff));
    u16 medium = get_offset((u16*)((void*)array));
    assert(medium == (value >> 16));
    u32 hard = get_misaligned((u16*)((void*)array));
    assert(hard == ((value << 16) | (value >> 16)));
    return 0;
}