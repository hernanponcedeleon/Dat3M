#include <assert.h>
#include <stddef.h>

// On i386 (clang -m32), long long is only 4-byte aligned inside structs:
// sizeof(struct S) == 12 and offsetof(struct S, b) == 4.
// Dartagnan's TypeFactory pads { i32, i64 } to 16 bytes instead.
struct S {
    int a;
    long long b;
};

struct S s;

// Field access through a pointer emits `getelementptr %struct.S, ptr %p, i32 0, i32 1`.
void set(struct S *p, long long v) {
    p->b = v;
}

int main(void) {
    _Static_assert(sizeof(struct S) == 12 || sizeof(void *) == 8, "unexpected i386 layout");
    set(&s, 42);
    assert(s.b == 42);
    return 0;
}
