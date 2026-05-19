#include <stdatomic.h>
#include <stdint.h>
#include <stdbool.h>

extern __thread uint32_t thread_numa_id;

typedef struct cna_node {
    _Atomic(struct cna_node *) next;
    atomic_bool locked;
    int32_t numa_id;
} cna_node_t;

typedef struct {
    _Atomic(cna_node_t *) tail;
    cna_node_t *secondary_head;
    cna_node_t *secondary_tail;
} cna_t;

typedef union {
    cna_t cna;
} lock_t;

typedef union {
    cna_node_t cna_node;
} lock_handle_t;




void cna_init(lock_t *lock)
{
   cna_t *cna = &lock->cna;
   cna->tail = NULL;
   cna->secondary_head = NULL;
   cna->secondary_tail = NULL;
}

// Enqueue current thread as new waiter.
void cna_lock(lock_t *lock, lock_handle_t *handle)
{
   cna_t *cna = &lock->cna;
   cna_node_t *node = &handle->cna_node;
   // Init new handle object
   node->next = NULL;
   node->numa_id = thread_numa_id;

   // Update tail pointer and get previous value
   cna_node_t *previous = atomic_exchange(&cna->tail, node);
   if (previous != NULL) {
       node->locked = true;
       previous->next = node;
       while (atomic_load(&node->locked)) {
           asm("PAUSE"); // Reduce CPU load
       }
   }
}

#ifndef FAIL

void cna_unlock(lock_t *lock, lock_handle_t *handle)
{
   cna_node_t *node = &handle->cna_node;
   cna_t *cna = &lock->cna;

   while (true) {
       // Try to put back secondary queue assuming we are the last node
       // in the primary queue.
       cna_node_t *old = node;
       cna_node_t* old_sec_tail = cna->secondary_tail;
       if (atomic_compare_exchange_strong(&cna->tail, &old, old_sec_tail)) {
           if (old_sec_tail != NULL) {
               // Some non-local waiters has been moved to main queue
               // Reset secondary queue
               node->next = cna->secondary_head;
               cna->secondary_head = NULL;
               cna->secondary_tail = NULL;
               // Wakeup non-local successor
               atomic_store(&node->next->locked, false);
           }
           return;
       }
       // There is at least one more waiter in the primary queue.
       // Wait until he updated our next pointer if not already done.
       while (atomic_load(&node->next) == NULL) {
           asm("PAUSE"); // Reduce CPU load
       }

       cna_node_t *waiter = node->next;
       if (waiter->numa_id != thread_numa_id) {
           // Waiter is non-local
           if (waiter->next != NULL) {
               // Skip one non-local waiter if there are more waiters
               // Move non-local waiter to secondary queue
               node->next = waiter->next;
               waiter->next = NULL;
               if (cna->secondary_head == NULL) {
                   cna->secondary_head = waiter;
               } else {
                   cna->secondary_tail->next = waiter;
               }
               cna->secondary_tail = waiter;
               continue;
           } else if (cna->secondary_tail) {
               // If only a single non-local waiter left,
               // merge secondary queue (if existing).
               node->next = cna->secondary_head;
               cna->secondary_tail->next = waiter;
               cna->secondary_head = NULL;
               cna->secondary_tail = NULL;
           }
       }
       // Unlock next waiter
       atomic_store(&node->next->locked, false);
       return;
   }

#else        // #ifdef FAIL

// This implementation is buggy:
// Termination failure under SC
// Under weaker models, also mutual exclusion failure / data races

void cna_unlock(lock_t *lock, lock_handle_t *handle)
{
    cna_node_t *node = &handle->cna_node;
    cna_t *cna = &lock->cna;

    while (true) {

        if (node->next == NULL) {
            // No waiting successor
            cna_node_t *old = node;
            // Try to put back secondary queue
            if (atomic_compare_exchange_strong(&cna->tail, &old, cna->secondary_tail)) {
                if (cna->secondary_tail != NULL) {
                    // Some non-local waiters has been moved to main queue
                    // Reset secondary queue
                    node->next = cna->secondary_head;
                    cna->secondary_head = NULL;
                    cna->secondary_tail = NULL;
                    // Wakeup non-local successor
                    atomic_store(&node->next->locked, false);
                }
                return;
            }
            // Someone tried to get the lock in the meantime
            // Wait until he updated our next pointer
            while (atomic_load(&node->next) == NULL) {
                asm("PAUSE"); // Reduce CPU load
            }
        }

        cna_node_t *waiter = node->next;
        if (waiter->numa_id != thread_numa_id) {
            // Waiter is non-local
            if (waiter->next != NULL) {
                // Skip one non-local waiter if there are more waiters
                // Move non-local waiter to secondary queue
                node->next = waiter->next;
                waiter->next = NULL;
                if (cna->secondary_head == NULL) {
                    cna->secondary_head = waiter;
                } else {
                    cna->secondary_tail->next = waiter;
                }
                cna->secondary_tail = waiter;
                continue;
            } else if (cna->secondary_tail) {
                // If only a single non-local waiter left,
                // merge secondary queue (if existing).
                node->next = cna->secondary_head;
                cna->secondary_tail->next = waiter;
                cna->secondary_head = NULL;
                cna->secondary_tail = NULL;
            }
        }
        // Unlock next waiter
        atomic_store(&node->next->locked, false);
        return;
    }
#endif
}