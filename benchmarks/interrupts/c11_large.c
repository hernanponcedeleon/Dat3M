#include <stdlib.h>
#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>
#include <dat3m.h>

// variant 0 is supposed to be safe, while variants 1 to 23 shall be unsafe.
#ifndef VARIANT
#define VARIANT 0
#endif

int x;
int y;
atomic_int z;

void reach(int variant, int condition)
{
    assert(VARIANT != variant || !condition);
}
void safe(int condition)
{
    assert(VARIANT != 0 || condition);
}

/// interrupts handler1
void *handler0(void* arg)
{
    // prevents handler2 from interrupting
    __VERIFIER_disable_irq();
    // cannot interrupt before creation
    safe((x & (1|16)) == (1|16) && (atomic_load(&z) & 1) == 1);
    x |= 256;

    // may or may not see z & N == N for N in {2,16,32,64,128}

    x |= 512;
    return NULL;
}

/// interrupts main
/// be interrupted by handler0 and optionally handler2
void *handler1(void* arg)
{
    // cannot interrupt before creation
    safe((x & 1) == 1);
    safe(((x & 4096) == 0) == ((x & 8192) == 0));
    // may interrupt main before or after handler2, but not handler2 itself, which disabled it
    reach(1, (x & (4096|8192)) == 0);
    reach(2, (x & (4096|8192)) == (4096|8192));

    x |= 16;

    __VERIFIER_make_cb();
    __VERIFIER_make_interrupt_handler();
    pthread_t h0;
    pthread_create(&h0, NULL, handler0, NULL);

    __VERIFIER_make_cb();
    __VERIFIER_disable_irq();
    x |= 32;

    __VERIFIER_make_cb();
    x |= 64;

    __VERIFIER_make_cb();
    __VERIFIER_enable_irq();

    __VERIFIER_disable_irq();

    __VERIFIER_make_cb();
    x |= 128;

    // may not have been interrupted, as if there is an implicit enable_irq at the end
    reach(3, (x & (256|512)) != (256|512));
    return NULL;
}

/// interrupts main or handler1
/// be interrupted by optionally handler1
void *handler2(void* arg)
{
    __VERIFIER_disable_irq();

    // cannot interrupt before creation
    safe((x & 1) == 1);

    // interactions w.r.t. main:
    int ax = x & (2|4|8);
    int az = atomic_load(&z) & (2|16|32|64|128);
    // may interrupt main immediately
    reach(4, ax == 0 && az == 0);
    // may interrupt main before x |= 2 but after atomic_fetch_or(&z, 2)
    reach(5, ax == 0 && az == 2);
    // may interrupt main after x |= 2 but before atomic_fetch_or(&z, 2)
    reach(6, ax == 2 && az == 0);
    // may interrupt main after both operations, but before x |= 4
    reach(7, ax == 2 && az == 2);
    // may interrupt main after x |= 4, but before pthread_join(t, NULL)
    reach(8, ax == (2|4) && az == 2);
    // may interrupt main after pthread_join(t, NULL), but before x |= 8
    reach(9, ax == (2|4) && az == (2|16|32|64|128));
    // may interrupt main after x |= 8
    reach(10, ax == (2|4|8) && az == (2|16|32|64|128));

    // interactions w.r.t handler0 and handler1:
    int bx = x & (16|32|64|128|256|512);
    // cannot observe side-effects of handler0 and handler1 out-of-order
    safe((bx & (16|256)) != 256 && (bx & (16|512)) != 512);
    safe(((bx & 256) == 0) == ((bx & 512) == 0));
    safe((bx & (16|32)) != 32);
    safe(((bx & 32) == 0) == ((bx & 64) == 0));
    safe((bx & (64|128)) != 128);
    // may interrupt main before handler1 (or handler1 immediately)
    reach(11, bx == 0);
    // may interrupt handler1 after x |= 16, but before x |= 32 and handler0
    reach(12, bx == 16);
    // may interrupt handler1 after x |= 64, but before x |= 128 and handler0
    reach(13, bx == (16|32|64));
    // may interrupt handler1 after x |= 128, but before handler0
    reach(14, bx == (16|32|64|128));
    // may interrupt handler1 after x |= 16 and handler0, but before x |= 32
    reach(15, bx == (16|256|512));
    // may interrupt handler1 after x |= 64 and handler0, but before x |= 128
    reach(16, bx == (16|32|64|256|512));
    // may interrupt main after handler1 (or handler1 at the end)
    reach(17, bx == (16|32|64|128|256|512));

    __VERIFIER_make_cb();
    x |= 4096;

    __VERIFIER_make_cb();
    x |= 8192;
    return NULL;
}

/// interrupts thread1 optionally
void *handler3(void* arg)
{
    // cannot interrupt before creation
    // cannot interrupt when disabled by thread1
    safe((y & (1|2|4|8)) == (1|2|4));
    int bz = atomic_load(&z);
    safe((bz & (1|16|32|128)) == (1|16|32));

    // may or may not interrupt thread1 before atomic_fetch_or(&z, 64)
    reach(18, (bz & 64) == 0);
    reach(19, (bz & 64) == 64);
    // may observe main or be observed by main
    reach(20, (bz & 2) == 0);
    reach(21, (bz & 2) == 2);

    y |= 16;
    return NULL;
}

void *thread1(void* arg)
{
    y |= 2;
    atomic_fetch_or(&z, 16);

    __VERIFIER_make_cb();
    __VERIFIER_disable_irq();
    pthread_t h3;
    if (__VERIFIER_nondet_bool())
    {
        __VERIFIER_make_interrupt_handler();
        pthread_create(&h3, NULL, handler3, NULL);
    }

    __VERIFIER_make_cb();
    y |= 4;
    atomic_fetch_or(&z, 32);

    __VERIFIER_enable_irq();
    atomic_fetch_or(&z, 64);

    __VERIFIER_disable_irq();
    y |= 8;
    atomic_fetch_or(&z, 128);
    // may or may not have been interrupted by handler3
    reach(22, (y & 16) == 0);
    reach(23, (y & 16) == 16);
    return NULL;
}

int main(void)
{
    x = 1;
    y = 1;
    atomic_init(&z, 1);
    // cannot be interrupted before creation
    safe((x | y) == 1 && atomic_load(&z) == 1);

    __VERIFIER_make_cb();
    pthread_t t;
    pthread_create(&t, NULL, thread1, NULL);

    pthread_t h1, h2;
    __VERIFIER_make_interrupt_handler();
    pthread_create(&h1, NULL, handler1, NULL);
    __VERIFIER_make_interrupt_handler();
    pthread_create(&h2, NULL, handler2, NULL);

    __VERIFIER_make_cb();
    x |= 2;
    atomic_fetch_or(&z, 2);

    __VERIFIER_make_cb();
    x |= 4;

    pthread_join(t, NULL);
    // no interrupt can bypass the local changes
    safe((x & (1|2)) == (1|2));
    // thread1 and handler3 finished
    safe(y == 31);

    x |= 8;

    return 0;
}