#include <stdatomic.h>
#include <dat3m.h>

#ifdef ACQ2RX_LOCK
#define mo_acq2rx_lock memory_order_relaxed
#else
#define mo_acq2rx_lock memory_order_acquire
#endif
#ifdef ACQ2RX_SUCC1
#define mo_acq2rx_succ1 memory_order_relaxed
#else
#define mo_acq2rx_succ1 memory_order_acquire
#endif
#ifdef ACQ2RX_SUCC2
#define mo_acq2rx_succ2 memory_order_relaxed
#else
#define mo_acq2rx_succ2 memory_order_acquire
#endif
#ifdef ACQ2RX_UNLOCK
#define mo_acq2rx_unlock memory_order_relaxed
#else
#define mo_acq2rx_unlock memory_order_acquire
#endif
#ifdef REL2RX_LOCK
#define mo_rel2rx_lock memory_order_relaxed
#else
#define mo_rel2rx_lock memory_order_release
#endif
#ifdef REL2RX_UNLOCK1
#define mo_rel2rx_unlock1 memory_order_relaxed
#else
#define mo_rel2rx_unlock1 memory_order_release
#endif
#ifdef REL2RX_UNLOCK2
#define mo_rel2rx_unlock2 memory_order_relaxed
#else
#define mo_rel2rx_unlock2 memory_order_release
#endif
#ifdef REL2RX_UNLOCK3
#define mo_rel2rx_unlock3 memory_order_relaxed
#else
#define mo_rel2rx_unlock3 memory_order_release
#endif
#ifdef REL2RX_UNLOCK4
#define mo_rel2rx_unlock4 memory_order_relaxed
#else
#define mo_rel2rx_unlock4 memory_order_release
#endif

int current_numa_node() {
    return __VERIFIER_nondet_uint();
}
 
_Bool keep_lock_local() {
    return __VERIFIER_nondet_bool();
}
 
typedef struct cna_node {
    _Atomic(uintptr_t) spin;
    _Atomic(int) socket;
    _Atomic(struct cna_node *) secTail;
    _Atomic(struct cna_node *) next;
} cna_node_t;
 
typedef struct {
    _Atomic(cna_node_t *) tail;
} cna_lock_t ;
 
cna_node_t* find_successor(cna_node_t *me) {
    cna_node_t *next = atomic_load_explicit(&me->next, memory_order_relaxed);
    int mySocket = atomic_load_explicit(&me->socket, memory_order_relaxed);
 
    if (mySocket == -1) mySocket = current_numa_node();
    if (atomic_load_explicit(&next->socket, memory_order_relaxed) == mySocket) return next;
   
    cna_node_t *secHead = next;
    cna_node_t *secTail = next;
    cna_node_t *cur = atomic_load_explicit(&next->next, mo_acq2rx_succ1);
   
    while(cur) {
        if(atomic_load_explicit(&cur->socket, memory_order_relaxed) == mySocket) {
            if(atomic_load_explicit(&me->spin, memory_order_relaxed) > 1) {
                cna_node_t *_spin = (cna_node_t*) atomic_load_explicit(&me->spin, memory_order_relaxed);
                cna_node_t *_secTail = atomic_load_explicit(&_spin->secTail, memory_order_relaxed);
                atomic_store_explicit(&_secTail->next, secHead, memory_order_relaxed);
            } else {
                atomic_store_explicit(&me->spin, (uintptr_t) secHead, memory_order_relaxed);
            }
            atomic_store_explicit(&secTail->next, NULL, memory_order_relaxed);
            cna_node_t *_spin = (cna_node_t*) atomic_load_explicit(&me->spin, memory_order_relaxed);
            atomic_store_explicit(&_spin->secTail, secTail, memory_order_relaxed);
            return cur;
        }
        secTail = cur;
        cur = atomic_load_explicit(&cur->next, mo_acq2rx_succ2);
    }
    return NULL;
}
 
static inline void cna_lock(cna_lock_t *lock, cna_node_t *me)
{
    atomic_store_explicit(&me->next, 0, memory_order_relaxed);
    atomic_store_explicit(&me->socket, -1, memory_order_relaxed);
    atomic_store_explicit(&me->spin, 0, memory_order_relaxed);
 
    /* Add myself to the main queue */
    cna_node_t *tail = atomic_exchange_explicit(&lock->tail, me, memory_order_seq_cst);
 
    /* No one there? */
    if(!tail) {
        atomic_store_explicit(&me->spin, 1, memory_order_relaxed);
        return;
    }
 
    /* Someone there, need to link in */
    atomic_store_explicit(&me->socket, current_numa_node(), memory_order_relaxed);
    atomic_store_explicit(&tail->next, me, mo_rel2rx_lock);
 
    /* Wait for the lock to become available */
    await_while(!atomic_load_explicit(&me->spin, mo_acq2rx_lock)) {
        //CPU_PAUSE();
    }
}
 
static inline void cna_unlock(cna_lock_t *lock, cna_node_t *me)
{
    /* Is there a successor in the main queue? */
    if(!atomic_load_explicit(&me->next, mo_acq2rx_unlock)) {
        /* Is there a node in the secondary queue? */
        if(atomic_load_explicit(&me->spin, memory_order_relaxed) == 1) {
            /* If not, try to set tail to NULL, indicating that both main and secondary queues are empty */
            cna_node_t *local_me = me;
            if(atomic_compare_exchange_strong_explicit(&lock->tail, &local_me, NULL, memory_order_seq_cst, memory_order_seq_cst)) {
                return;
            }
        } else {
            /* Otherwise, try to set tail to the last node in the secondary queue */
            cna_node_t *secHead = (cna_node_t *) atomic_load_explicit(&me->spin, memory_order_relaxed);
            cna_node_t *local_me = me;
            if(atomic_compare_exchange_strong_explicit(&lock->tail, &local_me,
                atomic_load_explicit(&secHead->secTail, memory_order_relaxed),
                memory_order_seq_cst, memory_order_seq_cst)) {
                /* If successful, pass the lock to the head of the secondary queue */
                atomic_store_explicit(&secHead->spin, 1, mo_rel2rx_unlock1);
                return;
            }
        }
        /* Wait for successor to appear */
        await_while(atomic_load_explicit(&me->next, memory_order_relaxed) == NULL) {
            //CPU_PAUSE();
        }
    }
    /* Determine the next lock holder and pass the lock by setting its spin field */
    cna_node_t *succ = NULL;
    if (keep_lock_local() && (succ = find_successor(me))) {
        atomic_store_explicit(&succ->spin,
            atomic_load_explicit(&me->spin, memory_order_relaxed),
            mo_rel2rx_unlock2);
    } else if(atomic_load_explicit(&me->spin, memory_order_relaxed) > 1) {
        succ = (cna_node_t *) atomic_load_explicit(&me->spin, memory_order_relaxed);
        atomic_store_explicit(
            &((cna_node_t *)atomic_load_explicit(&succ->secTail, memory_order_relaxed))->next,
            atomic_load_explicit(&me->next, memory_order_relaxed),
            memory_order_relaxed);
        atomic_store_explicit(&succ->spin, 1, mo_rel2rx_unlock3);
    } else {
        succ = (cna_node_t*) atomic_load_explicit(&me->next, memory_order_relaxed);
        atomic_store_explicit(&succ->spin, 1, mo_rel2rx_unlock4);
    }
}