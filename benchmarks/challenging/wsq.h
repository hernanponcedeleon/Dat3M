/********************************************************
*                                                       *
*     Copyright (C) Microsoft. All rights reserved.     *
*                                                       *
********************************************************/

#include <assert.h>
#include <stdatomic.h>

/* 
 * A WorkStealQueue is a wait-free, lock-free structure associated with a single
 * thread that can Push and Pop elements. Other threads can do Take operations
 * on the other end of the WorkStealQueue with little contention.
 *
 *  The following version comes from
 *      "The implementation of the CILK-5 multi-threaded language"
 *      Matteo Frigo, Charles Leiserson, and Keith Randall.
 *  and was adapted from the SVCOMP version 
 *      https://gitlab.com/sosy-lab/benchmarking/sv-benchmarks/-/blob/main/c/pthread-complex/workstealqueue_mutex-1.c
 */

#define STATICSIZE 16

typedef struct Obj {
    int field;
} Obj;

void init_Obj(Obj *r) {
    r->field = 0;
}

void operation(Obj *r) {
    r->field++;
}

void check(Obj *r) {
    assert(r->field == 1);
}

/*
 * A 'WorkStealQueue' always runs its code in a single OS thread. We call this the
 * 'bound' thread. Only the code in the Take operation can be executed by
 * other 'foreign' threads that try to steal work.
 *
 * The queue is implemented as an array. The head and tail index this
 * array. To avoid copying elements, the head and tail index the array modulo
 * the size of the array. By making this a power of two, we can use a cheap
 * bit-and operation to take the modulus. The "mask" is always equal to the
 * size of the task array minus one (where the size is a power of two).
 *
 * The head and tail are atomic as they can be updated from different OS threads.
 * The "head" is only updated by foreign threads as they Take (steal) a task from
 * this queue. By putting a lock in Take, there is at most one foreign thread
 * changing head at a time. The tail is only updated by the bound thread.
 *
 * invariants:
 *   tasks.length is a power of 2
 *   mask == tasks.length-1
 *   head is only written to by foreign threads
 *   tail is only written to by the bound thread
 *   At most one foreign thread can do a Take
 *   All methods except Take are executed from a single bound thread
 *   tail points to the first unused location
 */   

typedef struct WorkStealQueue {
    pthread_mutex_t cs;

    int MaxSize;
    int InitialSize;            // must be a power of 2

    atomic_int head;            // only updated by Take
    atomic_int tail;            // only updated by Push and Pop

    Obj*  elems[STATICSIZE];    // the array of tasks
    int mask;                   // the mask for taking modulus

} WorkStealQueue;


WorkStealQueue q;

int readV(atomic_int *v) {
    int expected = 0;
    atomic_compare_exchange_strong_explicit(v, &expected, 0, memory_order_seq_cst, memory_order_seq_cst);
    return expected;
}

void writeV(atomic_int *v, int w) {
    atomic_exchange_explicit(v, w, memory_order_seq_cst);
}

void init_WSQ(int size) {
    q.MaxSize = 1024 * 1024;
    q.InitialSize = 1024;
    pthread_mutex_init(&q.cs, NULL);
    writeV(&q.head, 0);
    q.mask = size - 1;
    writeV(&q.tail, 0);
}

void destroy_WSQ() {}

/*
 *  Push/Pop and Steal can be executed interleaved. In particular:
 * 1) A take and pop should be careful when there is just one element
 *    in the queue. This is done by first incrementing the head/decrementing the tail
 *    and than checking if it interleaved (head > tail).
 * 2) A push and take can interleave in the sense that a push can overwrite the
 *    value that is just taken. To account for this, we check conservatively in
 *    the push to assume that the size is one less than it actually is.
 */

_Bool steal(Obj **result) {
    _Bool found;
    pthread_mutex_lock(&q.cs);

    // ensure that at most one (foreign) thread writes to head
    // increment the head. Save in local h for efficiency

    int h = readV(&q.head);
    writeV(&q.head, h + 1);

    // insert a memory fence here if memory is not sequentially consistent

    if (h < readV(&q.tail)) {
        // == (h+1 <= tail) == (head <= tail)
        // BUG: writeV(&q.head, h + 1);
        int temp = h & q.mask;
        *result = q.elems[temp];
        found = 1;
    } else {
        // failure: either empty or single element interleaving with pop
        writeV(&q.head, h);              // restore the head
        found = 0;
    }
    pthread_mutex_unlock(&q.cs);
    return found;
}

_Bool syncPop(Obj **result) {
    _Bool found;

    pthread_mutex_lock(&q.cs);

    // ensure that no Steal interleaves with this pop
    int t = readV(&q.tail) - 1;
    writeV(&q.tail, t);
    if (readV(&q.head) <= t) {
        // == (head <= tail)
        int temp = t & q.mask;
        *result = q.elems[temp];
        found = 1;
    } else {
        writeV(&q.tail, t + 1);       // restore tail
        found = 0;
    }
    if (readV(&q.head) > t) {
        // queue is empty: reset head and tail
        writeV(&q.head, 0);
        writeV(&q.tail, 0);
        found = 0;
    }
    pthread_mutex_unlock(&q.cs);
    return found;
}

_Bool pop(Obj **result) {
    // decrement the tail. Use local t for efficiency.
    int t = readV(&q.tail) - 1;
    writeV(&q.tail, t);

    // insert a memory fence here if memory is not sequentially consistent
    if (readV(&q.head) <= t) {
        // BUG:  writeV(&q.tail, t);
        // == (head <= tail)
        int temp = t & q.mask;
        *result = q.elems[temp];
        return 1;
    } else {
        // failure: either empty or single element interleaving with take
        writeV(&q.tail, t + 1);             // restore the tail
        return syncPop(result);   // do a single-threaded pop
    }
}

void syncPush(Obj* elem) {
    pthread_mutex_lock(&q.cs);
    // ensure that no Steal interleaves here
    // cache head, and calculate number of tasks
    int h = readV(&q.head);
    int count = readV(&q.tail) - h;

    // normalize indices
    h = h & q.mask;           // normalize head
    writeV(&q.head, h);
    writeV(&q.tail, h + count);

    // check if we need to enlarge the tasks
    if (count >= q.mask) {
        // == (count >= size-1)
        int newsize = (q.mask == 0 ? q.InitialSize : 2 * (q.mask + 1));

        assert(newsize < q.MaxSize);

        Obj *newtasks[STATICSIZE];
        int i;
        for (i = 0; i < count; i++) {
            int temp = (h + i) & q.mask;
            newtasks[i] = q.elems[temp];
        }
        for (i = 0; i < newsize; i++) {
            q.elems[i] = newtasks[i];
        }
        // q.elems = newtasks;
        q.mask = newsize - 1;
        writeV(&q.head, 0);
        writeV(&q.tail, count);
    }

    assert(count < q.mask);

    // push the element
    int t = readV(&q.tail);
    int temp = t & q.mask;
    q.elems[temp] = elem;
    writeV(&q.tail, t + 1);
    pthread_mutex_unlock(&q.cs);
}


/* 
 * Careful here since we might interleave with Steal.
 * This is no problem since we just conservatively check if there is
 * enough space left (t < head + size). However, Steal might just have
 * incremented head and we could potentially overwrite the old head
 * entry, so we always leave at least one extra 'buffer' element and
 * check (tail < head + size - 1). This also plays nicely with our
 * initial mask of 0, where size is 2^0 == 1, but the tasks array is
 * still null.
 */

void push(Obj* elem) {
    int t = readV(&q.tail);
    // Correct: if (t < readV(&q.head) + mask && t < MaxSize)
#ifdef FAIL
    if (t < readV(&q.head) + q.mask + 1 && t < q.MaxSize)
#else
    if (t < readV(&q.head) + q.mask   // == t < head + size - 1
            && t < q.MaxSize)
#endif
    {
        int temp = t & q.mask;
        q.elems[temp] = elem;
        writeV(&q.tail, t + 1);       // only increment once we have initialized the task entry.
    } else {
        // failure: we need to resize or re-index
        syncPush(elem);
    }
}