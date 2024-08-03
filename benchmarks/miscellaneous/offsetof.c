#include <stddef.h>
#include <dat3m.h>

#define container_of(ptr, type, member) ({                      \
        const typeof( ((type *)0)->member ) *__mptr = (ptr);    \
        (type *)((char *)__mptr - offsetof(type,member));})

typedef struct {
    int x; // 4 byte padding
    struct {
      long a;
      char b; // 7 byte padding
    };
    int z; // 4 byte padding
} myStruct_t; // Total size: 32 bytes, because all 4 members are 8-byte aligned

myStruct_t myStruct;

int main()
{
    // These assertions are trivialized by the compiler even without any opt passes
    __VERIFIER_assert(sizeof(myStruct_t) == 32);
    __VERIFIER_assert(offsetof(myStruct_t, z) == 24);

    // This is not trivialized without optimizations (some standard opt passes can trivialize this though)
    myStruct_t *container = container_of(&myStruct.z, myStruct_t, z);
    __VERIFIER_assert(container == &myStruct);
}
