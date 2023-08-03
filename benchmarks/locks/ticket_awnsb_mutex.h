/******************************************************************************
 * Copyright (c) 2014-2015, Pedro Ramalhete, Andreia Correia
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of Concurrency Freaks nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 ******************************************************************************
 */

/*
  * <h1>Ticket Lock with Array of Waiting Nodes</h1>
 * This is a variant of the Ticket Lock where each thread spins on its own node.
 *
 * <h2> Spins on Both variant </h2>
 * In this variant, at the end of the lock() method, we have to spin on both
 * egress and lockIsMine if and only if egress is ticket-1.
 *
 * <h2> Ticket Lock behavior </h2>
 * The Ticket Lock is described in section 2.2 by John Mellor-Crummey and
 * Michael Scott in 1991:
 * <a href="http://web.mit.edu/6.173/www/currentsemester/readings/R06-scalable-synchronization-1991.pdf">
 * http://web.mit.edu/6.173/www/currentsemester/readings/R06-scalable-synchronization-1991.pdf</a>
 * <br>This variant's behavior is a follows:
 * <ul>
 * <li> ticket == egress:   Works like a Ticket Lock
 * <li> ticket-1 == egress: Works like a ticket Lock
 * <li> ticket-2 >= egress: Uses the new mechanism
 * </ul>
 *
 * <h2> Comparison with CLH </h2>
 * This algorithm does more work than CLH so it's not that better, but in a
 * machine where there is no single instruction atomic_exchange() or it is much
 * slower than atomic_fetch_add(), this technique could be better than CLH. <br>
 * There is an advantage over CLH: In Ticket AWN there is a single awn_node_t
 * instance per thread that is shared among all instances of Ticket AWN, while
 * on the CLH there must be one node per instance per thread. This means that
 * memory wise, if an array of MAX_THREADS is used for the Ticket AWN, the
 * Ticket AWN should consume slightly less memory overall:
 * <ul>
 * <li> CLH: sizeof(node) x Number of instances x MAX_THREADS
 * <li> Ticket AWN: (sizeof(node) x MAX_THREADS) + (sizeof(ptr) x Number of instances x maxArrayWaiters)
 * </ul>
 *
 * <h2> Happens-Before </h2>
 * Notice that on {@code unlock()} we write on {@code wnode.isLocked} and then
 * on {@code egress}, while on lock() we read {@code egress} and then
 * {@code wnode.islocked}, which creates a Happens-Before:
 * <ul>
 * <li>lock(): waitersArray.store() -> egress.load() -> lockIsMine.load()
 * <li>unlock(): waitersArray.load() -> lockIsMine.store() -> egress.store()
 * <li>unlock(): waitersArray.load() -> egress.store()
 * </ul>
 * <h2> Sample scenario </h2>
 * To understand how the negative/positive egress mechanism works, imagine a
 * sample scenario where Thread 1 (T1) gets a ticket of 10:
 * <ul>
 * <li> egress is 10: T1 has the lock
 * <li> egress is 9: T1 will add its node to the waitersArray and will spin
 * both on egress and lockIsMine it will exit when:
 * <ul>
 *   <li> egress is 10: T1 has the lock
 *   <li> lockIsMine is true: T1 has the lock and sets egress to 10
 *   </ul>
 * <li> egress is 8: T1 will add its node to the waitersArray and wait until
 * lockIsMine is true, once lockIsMine is true T1 has the lock and sets egress to 10
 * </ul>
 *
 * <h2> Atomic Operations </h2>
 * Notice that in Ticket AWN the only atomic operation that is not a simple
 * load or store is the atomic_fetch_add() done at the beginning of the
 * lock() method. No other atomic_fetch_add(), or atomic_exchange() or
 * atomic_compare_exchange() are done on this algorithm, and several of the
 * atomic loads and stores can be done relaxed.
 *
 * <h2> Relaxed Atomic Operations </h2>
 * There are a few loads and stores than can be done relaxed. Here is the
 * list and the justification:
 * <ul>
 * <li> In lock(), the store on wnode->lockIsMine to false can be relaxed
 *      because it will become visible on the release-store of the wnode in
 *      the array and it will only be accessible from that instant in time.
 * <li> In lock(), the store to egress of ticket can be made relaxed
 *      because it will become visible at the end of unlock() when we do a
 *      store with release on either lockIsMine or egress.
 * <li> In unlock(), the first load on egress can be relaxed because it was
 *      read last by the same thread in lock() so it is guaranteed to be up
 *      to date.
 * <li> In unlock(), the store on the self entry of the array to NULL can be
 *      relaxed because it will become visible either with the store with
 *      release on the wnode->lockIsMine to true or on the egress to ticket+1.
 * </ul>
 *
 * @author Andreia Correia
 * @author Pedro Ramalhete
 */

#include <stdatomic.h>
#include <stdlib.h>
#include <errno.h>          // Needed by EBUSY
#include <dat3m.h>

#define DEFAULT_MAX_WAITERS  3

typedef struct {
    atomic_int lockIsMine;
} awnsb_node_t;

typedef struct
{
    atomic_int ingress;
    char padding1[8];      // To avoid false sharing with the ingress and egress
    atomic_int egress;
    char padding2[8];
    int maxArrayWaiters;
    _Atomic(awnsb_node_t *)* waitersArray;
} ticket_awnsb_mutex_t;

/*
 * Each thread has its own awnsb_node_t instance. The design goal is for each
 * thread waiting on the lock to be spinning on its own copy if the awn_node_t
 * instance in the lockIsMine variable, instead of all threads spinning on the
 * egress variable, thus reducing traffic on the cache-coherence system.
 */
static __thread awnsb_node_t tlNode;

/**
 * If you don't know what to put in maxArrayWaiters just use DEFAULT_MAX_WAITERS
 *
 * @param maxArrayWaiters Size of the array of waiter threads. We recommend
 *                        using the number of cores or at most the number of
 *                        threads expected to concurrently attempt to acquire
 *                        the lock.
 */
void ticket_awnsb_mutex_init(ticket_awnsb_mutex_t * self, int maxArrayWaiters)
{
    atomic_init(&self->ingress, 0);
    atomic_init(&self->egress, 0);
    self->maxArrayWaiters = maxArrayWaiters;
    self->waitersArray = (_Atomic(awnsb_node_t *)*)malloc(self->maxArrayWaiters*sizeof(awnsb_node_t *));
    __VERIFIER_loop_bound(DEFAULT_MAX_WAITERS+1);
    for (int i = 0; i < self->maxArrayWaiters; i++) atomic_init(&self->waitersArray[i], NULL);
}


void ticket_awnsb_mutex_destroy(ticket_awnsb_mutex_t * self)
{
    atomic_store(&self->ingress, 0);
    atomic_store(&self->egress, 0);
    free(self->waitersArray);
}

/*
 * Locks the mutex
 * Progress Condition: Blocking
 *
 * Notice that in the best case scenario there will be two acquires and one
 * release barriers, in atomic_fetch_add() on ingress, and in the first
 * atomic_load() of egress.
 */
void ticket_awnsb_mutex_lock(ticket_awnsb_mutex_t * self)
{
    const int ticket = atomic_fetch_add_explicit(&self->ingress, 1, memory_order_relaxed);
#ifdef FAIL
    if (atomic_load_explicit(&self->egress, memory_order_relaxed) == ticket) return;
#else
    if (atomic_load_explicit(&self->egress, memory_order_acquire) == ticket) return;
#endif
    while (atomic_load_explicit(&self->egress, memory_order_relaxed) >= ticket-1) {
        if (atomic_load_explicit(&self->egress, memory_order_acquire) == ticket) return;
    }
    // If there is no slot to wait, spin until there is
    while (ticket-atomic_load_explicit(&self->egress, memory_order_relaxed) >= (self->maxArrayWaiters-1));

    // There is a spot for us on the array, so place our node there
    awnsb_node_t * wnode = &tlNode;
    // Reset lockIsMine from previous usages
    atomic_store_explicit(&wnode->lockIsMine, 0, memory_order_relaxed);
    atomic_store_explicit(&self->waitersArray[(int)(ticket % self->maxArrayWaiters)], wnode, memory_order_release);

    if (atomic_load_explicit(&self->egress, memory_order_relaxed) < ticket-1) {
        // Spin on lockIsMine
        while (!atomic_load_explicit(&wnode->lockIsMine, memory_order_relaxed));
        atomic_store_explicit(&self->egress, ticket, memory_order_relaxed);
    } else {
        // Spin on both lockIsMine and egress
        while (atomic_load_explicit(&self->egress, memory_order_acquire) != ticket) {
            if (atomic_load_explicit(&wnode->lockIsMine, memory_order_acquire)) {
                atomic_store_explicit(&self->egress, ticket, memory_order_relaxed);
                return; // Lock acquired
            }
        }
    }
    // Lock acquired
}


/*
 * Unlocks the mutex
 * Progress Condition: Wait-Free Population Oblivious
 *
 * Notice that in this function there is only one release barrier and one acquire barrier.
 */
void ticket_awnsb_mutex_unlock(ticket_awnsb_mutex_t * self)
{
    int ticket = atomic_load_explicit(&self->egress, memory_order_relaxed);
    // Clear up our entry in the array before releasing the lock.
    atomic_store_explicit(&self->waitersArray[(int)(ticket % self->maxArrayWaiters)], NULL, memory_order_relaxed);
    // We could do this load as relaxed per se but then the store on egress of -(ticket+1) could be re-ordered to be before, and we don't want that
    awnsb_node_t * wnode = atomic_load_explicit(&self->waitersArray[(int)((ticket+1) % self->maxArrayWaiters)], memory_order_acquire);
    if (wnode != NULL) {
        // We saw the node in waitersArray
        atomic_store_explicit(&wnode->lockIsMine, 1, memory_order_release);
    } else {
        atomic_store_explicit(&self->egress, ticket+1, memory_order_release);
    }
}


/*
 * Tries to lock the mutex
 * Returns 0 if the lock has been acquired and EBUSY otherwise
 * Progress Condition: Wait-Free Population Oblivious
 */
int ticket_awnsb_mutex_trylock(ticket_awnsb_mutex_t * self)
{
    int localE = atomic_load(&self->egress);
    int localI = atomic_load_explicit(&self->ingress, memory_order_relaxed);
    if (localE != localI) return EBUSY;
    if (!atomic_compare_exchange_strong(&self->ingress, &localI, self->ingress+1)) return EBUSY;
    // Lock has been acquired
    return 0;
}