#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <pthread.h>
#include <stdatomic.h>
#include <assert.h>

// futex.h
//
static atomic_int sig;

static inline void __futex_wait(atomic_int *m, int v)
{
    int s = atomic_load_explicit(&sig, memory_order_acquire);
    if (atomic_load_explicit(m, memory_order_acquire) != v)
        return;

    while (atomic_load_explicit(&sig, memory_order_acquire) == s)
        ;
}

static inline void __futex_wake(atomic_int *m, int v)
{
    atomic_fetch_add_explicit(&sig, 1, memory_order_release);
}

typedef struct cna_node {
    uintptr_t spin;
    int socket;
    struct cna_node *secTail;
    struct cna_node *next;
} cna_node_t;

typedef struct {
    cna_node_t *tail;
} cna_lock_t ;

typedef struct {
    atomic_int lock;
    atomic_int waiters;
} mutex_t;

static inline void mutex_init(mutex_t *m);
static inline int mutex_lock_fastpath(mutex_t *m);
static inline int mutex_lock_slowpath_check(mutex_t *m);
static inline void cna_lock(mutex_t *m);
static inline void cna_unlock(mutex_t *m);

// mutex_musl.c
//
static inline void mutex_init(mutex_t *m)
{
    atomic_init(&m->lock, 0);
    atomic_init(&m->waiters, 0);
}


static inline void cna_lock(cna_lock_t *lock, cna_node_t *me)
{
    me->next = 0;
    me->socket = -1;
    me->spin = 0;
    
    /* Add myself to the main queue */
    cna_node_t *tail = atomic_exchange_explicit(&lock->tail, me, memory_order_seq_cst);
    
    /* No one there? */
    if(! tail) {me-> spin = 1;return;}
    
    /* Someone there, need to link in */
    //me->socket = current_numa_node();
    atomic_store_explicit(&tail->next, me, memory_order_release);
    
    /* Wait for the lock to become available */
    atomic_load_explicit(&me->spin, memory_order_acquire)
    while(!me->spin){//CPU_PAUSE();
    }
}

static inline cna_unlock(cna_lock_t *lock, cna_node_t *me)
{
    if(!atomic_load_explicit(&me->next, memory_order_acquire)) {
        if(me->spin == 1) {
            if(atomic_compare_exchange_strong_explicit(&lock->tail, me, NULL, memory_order_seq_cst, memory_order_seq_cst) == me) return;
        } else {
            cna_node_t *secHead (cna_node_t *) me->spin;
            if(atomic_compare_exchange_strong_explicit(&lock->tail, me, secHead->secTail, memory_order_seq_cst, memory_order_seq_cst) == me) {
                atomic_store_explicit(&secHead->spin, 1, memory_order_release);
                return;
            }
        }
        while(me->next == NULL){//CPU_PAUSE();
        }
    }
    cna_node_t *succ = NULL;
    if (//keep_lock_local() &&
        (succ = find_successor(me))) {
        atomic_store_explicit(&succ->spin, me->spin, memory_order_release);
    } else if(me-> spin > 1) {
        such = (cna_node_t *) me->spin;
        succ->secHead->next = me->next;
        atomic_store_explicit(&succ->spin, 1, memory_order_release);
    } else {
        atomic_store_explicit(&me->next->spin, 1, memory_order_release);
    }
}


// main.c
//
int shared;
mutex_t* mutex;

void *thread_n(void *arg)
{
    intptr_t index = ((intptr_t) arg);

    cna_lock(mutex);
    shared = index;
    int r = shared;
    assert(r == index);
    cna_unlock(mutex);
    return NULL;
}

// variant
//
int main()
{
    pthread_t t0, t1, t2;
    mutex = malloc(sizeof(mutex_t));
    mutex_init(mutex);

    pthread_create(&t0, NULL, thread_n, (void *) 0);
    pthread_create(&t1, NULL, thread_n, (void *) 1);
    pthread_create(&t2, NULL, thread_n, (void *) 2);
    
    return 0;
}
