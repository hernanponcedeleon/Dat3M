/*
 * brg-pk: the barging/parking kernel mutex of OpenBSD.
 *
 * D. Gwynne, R. Colvin, B. Dongol, R. Su, D. Wright.
 * "brg-pk: A Practical Verified High-Throughput Kernel Lock for OpenBSD".
 * SIGOPS ATC 2026. https://doi.org/10.1145/3828523.3857131
 *
 * The labels a1..a19 and r1..r5 refer to the lines of the pseudocode.
 *
 * Memory orders follow the barrier placement justified in Sec. 6 of the paper:
 * every atomic access is relaxed and ordering comes only from explicit barriers:
 *   - a barrier at the end of acquire        (acquire fence)
 *   - a barrier at the beginning of release  (release fence)
 *   - a13: set up of the waiter node / joining the queue must happen strictly
 *          before the CAS on the mutex     (full fence)
 *   - r4:  freeing the lock must happen before notifying a parked waiter
 *                                           (full fence)
 *
 * The parking lot is a doubly linked list whose operations are made atomic by
 * a CAS-based spinlock (Sec. 4.1).
 */
#include <stdatomic.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#ifndef BRGPK_MID_ITERS
#define BRGPK_MID_ITERS 40 // number of middle-path iterations (footnote 3)
#endif

/* The lock word: owner id with the contended bit in the lowest bit.
 * Owner ids are even (in OpenBSD they are aligned per-CPU pointers). */
typedef atomic_uintptr_t brgpk_mutex_t;
#define BRGPK_CONTENDED ((uintptr_t)1)

struct brgpk_waiter {
    brgpk_mutex_t *mtx;            // protected by the parking-lot lock
    atomic_bool wait;              // spun on outside of the parking-lot lock
    struct brgpk_waiter *next;     // protected by the parking-lot lock
    struct brgpk_waiter *prev;     // protected by the parking-lot lock
};

/* ---------------------------- parking lot ---------------------------- */

struct brgpk_parking_lot {
    atomic_int lock;
    struct brgpk_waiter *head;
    struct brgpk_waiter *tail;
};

static struct brgpk_parking_lot brgpk_pl;

static inline void brgpk_pl_enter(struct brgpk_parking_lot *pl)
{
    int expected;
    do {
        while (atomic_load_explicit(&pl->lock, memory_order_relaxed) != 0)
            ;
        expected = 0;
    } while (!atomic_compare_exchange_strong_explicit(&pl->lock, &expected, 1,
                memory_order_acquire, memory_order_relaxed));
}

static inline void brgpk_pl_leave(struct brgpk_parking_lot *pl)
{
    atomic_store_explicit(&pl->lock, 0, memory_order_release);
}

static inline void brgpk_append(struct brgpk_parking_lot *pl, struct brgpk_waiter *wtr)
{
    brgpk_pl_enter(pl);
    wtr->next = NULL;
    wtr->prev = pl->tail;
    if (pl->tail != NULL)
        pl->tail->next = wtr;
    else
        pl->head = wtr;
    pl->tail = wtr;
    brgpk_pl_leave(pl);
}

static inline void brgpk_remove(struct brgpk_parking_lot *pl, struct brgpk_waiter *wtr)
{
    brgpk_pl_enter(pl);
    if (wtr->prev != NULL)
        wtr->prev->next = wtr->next;
    else
        pl->head = wtr->next;
    if (wtr->next != NULL)
        wtr->next->prev = wtr->prev;
    else
        pl->tail = wtr->prev;
    brgpk_pl_leave(pl);
}

static inline void brgpk_wake_first(struct brgpk_parking_lot *pl, brgpk_mutex_t *mtx)
{
    brgpk_pl_enter(pl);
    for (struct brgpk_waiter *wtr = pl->head; wtr != NULL; wtr = wtr->next) {
        if (wtr->mtx == mtx) {
            atomic_store_explicit(&wtr->wait, false, memory_order_relaxed);
            break;
        }
    }
    brgpk_pl_leave(pl);
}

/* ------------------------------- mutex ------------------------------- */

static inline void brgpk_mutex_init(brgpk_mutex_t *mtx)
{
    atomic_init(mtx, 0);
}

/* r = cas(x, o, n): returns the value of x before the operation. */
static inline uintptr_t brgpk_cas(brgpk_mutex_t *mtx, uintptr_t o, uintptr_t n)
{
    atomic_compare_exchange_strong_explicit(mtx, &o, n,
            memory_order_relaxed, memory_order_relaxed);
    return o;
}

/* self must be non-zero and have the contended bit clear. */
static inline void brgpk_mutex_enter(brgpk_mutex_t *mtx, struct brgpk_waiter *wtr, uintptr_t self)
{
    uintptr_t owner, o;

    owner = brgpk_cas(mtx, 0, self);                                          // a2
    if (owner == 0)                                                           // a3
        goto acquired;

    for (int i = 0; i < BRGPK_MID_ITERS; i++) {                               // a4
        if (owner & BRGPK_CONTENDED)                                          // a5
            break;
        if (atomic_load_explicit(mtx, memory_order_relaxed) == 0) {           // a6
            owner = brgpk_cas(mtx, 0, self);                                  // a7
            if (owner == 0)                                                   // a8
                goto acquired;
        }
    }

    wtr->mtx = mtx;                                                           // a9
    brgpk_append(&brgpk_pl, wtr);                                             // a10
    do {                                                                      // a11
        atomic_store_explicit(&wtr->wait, true, memory_order_relaxed);        // a12
        atomic_thread_fence(memory_order_seq_cst);                            // a13
        o = brgpk_cas(mtx, owner, owner | BRGPK_CONTENDED);                   // a14
        if (o == owner) {                                                     // a15
            while (atomic_load_explicit(&wtr->wait, memory_order_relaxed))    // a16
                ;
        }
        // The paper uses cas(mtx,0,self), which has a termination bug: clearing
        // the contended bit can leave a parked thread that is never woken up.
        // We use self|1 as in OpenBSD's kern_lock.c; -DFAIL gives the paper's version.
#ifdef FAIL
        owner = brgpk_cas(mtx, 0, self);                                      // a17
#else
        owner = brgpk_cas(mtx, 0, self | BRGPK_CONTENDED);                    // a17
#endif
    } while (owner != 0);                                                     // a18
    brgpk_remove(&brgpk_pl, wtr);                                             // a19

acquired:
    atomic_thread_fence(memory_order_acquire);
}

static inline void brgpk_mutex_leave(brgpk_mutex_t *mtx, uintptr_t self)
{
    uintptr_t owner;

    atomic_thread_fence(memory_order_release);
    owner = brgpk_cas(mtx, self, 0);                                          // r1
    if (owner != self) {                                                      // r2
        atomic_store_explicit(mtx, 0, memory_order_relaxed);                  // r3
        atomic_thread_fence(memory_order_seq_cst);                            // r4
        brgpk_wake_first(&brgpk_pl, mtx);                                     // r5
    }
}
