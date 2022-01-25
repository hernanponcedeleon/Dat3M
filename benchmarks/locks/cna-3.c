#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <pthread.h>
#include <stdatomic.h>
#include <assert.h>

extern int __VERIFIER_nondet_int(void);

int current_numa_node() {
    return 0;
//    return __VERIFIER_nondet_int();
}

_Bool keep_lock_local() {
    return __VERIFIER_nondet_int() != 0;
}

typedef struct cna_node {
    _Atomic(uintptr_t) spin;
    int socket;
    _Atomic(struct cna_node *) secTail;
    _Atomic(struct cna_node *) next;
} cna_node_t;

typedef struct {
    _Atomic(struct cna_node_t *) tail;
} cna_lock_t ;

cna_node_t* find_successor(cna_node_t *me) {
    cna_node_t *next = me->next;
    int mySocket = me->socket;
    
    if (mySocket == -1) mySocket = current_numa_node();
    if (next->socket == mySocket) return next;
    
    cna_node_t *secHead = next;
    cna_node_t *secTail = next;
    cna_node_t *cur = atomic_load_explicit(&next->next, memory_order_acquire);
    
    while(cur) {
        if(cur->socket == mySocket) {
            if(me->spin > 1) {
                ((cna_node_t *)(me->spin))->secTail->next = secHead;
            } else {
                me->spin = (uintptr_t) secHead;
            }
            secTail->next = NULL;
            ((cna_node_t *)(me->spin))->secTail = secTail;
            return cur;
        }
        secTail = cur;
        cur = atomic_load_explicit(&cur->next, memory_order_acquire);
    }
    return NULL;
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
    me->socket = current_numa_node();
    atomic_store_explicit(&tail->next, me, memory_order_release);

    /* Wait for the lock to become available */
    while(!atomic_load_explicit(&me->spin, memory_order_acquire)){
        //CPU_PAUSE();
    }
}

static inline void cna_unlock(cna_lock_t *lock, cna_node_t *me)
{
    /* Is there a successor in the main queue? */
    if(!atomic_load_explicit(&me->next, memory_order_acquire)) {
        /* Is there a node in the secondary queue? */
        if(me->spin == 1) {
            /* If not, try to set tail to NULL, indicating that both main and secondary queues are empty */
            if(atomic_compare_exchange_strong_explicit(&lock->tail, me, NULL, memory_order_seq_cst, memory_order_seq_cst) == me) {
                return;
            }
        } else {
            /* Otherwise, try to set tail to the last node in the secondary queue */
            cna_node_t *secHead = (cna_node_t *) me->spin;
            if(atomic_compare_exchange_strong_explicit(&lock->tail, me, secHead->secTail, memory_order_seq_cst, memory_order_seq_cst) == me) {
                /* If successful, pass the lock to the head of the secondary queue */
                atomic_store_explicit(&secHead->spin, 1, memory_order_release);
                return;
            }
        }
        /* Wait for successor to appear */
        while(me->next == NULL){
            //CPU_PAUSE();
        }
    }
    /* Determine the next lock holder and pass the lock by setting its spin field */
    cna_node_t *succ = NULL;
    if (keep_lock_local() && (succ = find_successor(me))) {
        atomic_store_explicit(&succ->spin, me->spin, memory_order_release);
    } else if(me-> spin > 1) {
        succ = (cna_node_t *) me->spin;
        succ->secTail->next = me->next;
        atomic_store_explicit(&succ->spin, 1, memory_order_release);
    } else {
        atomic_store_explicit(&me->next->spin, 1, memory_order_release);
    }
}

cna_lock_t lock;
cna_node_t node[4];
int shared = 0;

void *thread_n(void *arg)
{
    intptr_t index = ((intptr_t) arg);

    cna_lock(&lock, &node[index]);
    shared = index;
    int r = shared;
    assert(r == index);
    cna_unlock(&lock, &node[index]);
    return NULL;
}

int main()
{
    pthread_t t0, t1, t2, t3;

    pthread_create(&t0, NULL, thread_n, (void *) 0);
    pthread_create(&t1, NULL, thread_n, (void *) 1);
    pthread_create(&t2, NULL, thread_n, (void *) 2);
    pthread_create(&t3, NULL, thread_n, (void *) 3);
    
    return 0;
}
