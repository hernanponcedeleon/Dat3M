#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <pthread.h>
#include <stdatomic.h>
#include <assert.h>

// my_queue.h
//
#define MAX_NODES            0xf

typedef unsigned long long pointer;
typedef atomic_ullong pointer_t;

#define MAKE_POINTER(ptr, count)    ((((pointer)count) << 32) | ptr)
#define PTR_MASK 0xffffffffLL
#define COUNT_MASK (0xffffffffLL << 32)

static inline void set_count(pointer *p, unsigned int val) { *p = (*p & ~COUNT_MASK) | ((pointer)val << 32); }
static inline void set_ptr(pointer *p, unsigned int val) { *p = (*p & ~PTR_MASK) | val; }
static inline unsigned int get_count(pointer p) { return (p & COUNT_MASK) >> 32; }
static inline unsigned int get_ptr(pointer p) { return p & PTR_MASK; }

typedef struct node {
    unsigned int value;
    pointer_t next;
} node_t;

typedef struct {
    pointer_t head;
    pointer_t tail;
    node_t nodes[MAX_NODES + 1];
} queue_t;

void init_queue(queue_t *q, int num_threads);
void enqueue(queue_t *q, unsigned int val);
bool dequeue(queue_t *q, unsigned int *retVal);
int get_thread_num();

// my_queue.c
//
#ifdef MAKE_ACCESSES_SC
# define relaxed memory_order_seq_cst
# define release memory_order_seq_cst
# define acquire memory_order_seq_cst
#else
# define relaxed memory_order_relaxed
# define release memory_order_release
# define acquire memory_order_acquire
#endif

#ifndef MAX_THREADS
# define MAX_THREADS 32
#endif

#define MAX_FREELIST 4 /* Each thread can own up to MAX_FREELIST free nodes */
#define INITIAL_FREE 2 /* Each thread starts with INITIAL_FREE free nodes */

#define POISON_IDX 0x666

static unsigned int free_lists[MAX_THREADS][MAX_FREELIST];

void __VERIFIER_assume(int);

/* Search this thread's free list for a "new" node */
static unsigned int new_node()
{
    int i;
    int t = get_thread_num();
    for (i = 0; i < MAX_FREELIST; i++) {
        unsigned int node = free_lists[t][i];
        if (node) {
            free_lists[t][i] = 0;
            return node;
        }
    }
    /* free_list is empty? */
    assert(0);
    return 0;
}

/* Place this node index back on this thread's free list */
static void reclaim(unsigned int node)
{
    int i;
    int t = get_thread_num();

    /* Don't reclaim NULL node */
    assert(node);

    for (i = 0; i < MAX_FREELIST; i++) {
        /* Should never race with our own thread here */
        unsigned int idx = free_lists[t][i];

        /* Found empty spot in free list */
        if (idx == 0) {
            free_lists[t][i] = node;
            return;
        }
    }
    /* free list is full? */
    assert(0);
}

void init_queue(queue_t *q, int num_threads)
{
    int i, j;

    /* Initialize each thread's free list with INITIAL_FREE pointers */
    /* The actual nodes are initialized with poison indexes */
    for (i = 0; i < num_threads; i++) {
        for (j = 0; j < INITIAL_FREE; j++) {
            free_lists[i][j] = 2 + i * MAX_FREELIST + j;
            atomic_init(&q->nodes[free_lists[i][j]].next, MAKE_POINTER(POISON_IDX, 0));
        }
    }

    /* initialize queue */
    atomic_init(&q->head, MAKE_POINTER(1, 0));
    atomic_init(&q->tail, MAKE_POINTER(1, 0));
    atomic_init(&q->nodes[1].next, MAKE_POINTER(0, 0));
}

void enqueue(queue_t *q, unsigned int val)
{
    int success = 0;
    unsigned int node;
    pointer tail;
    pointer next;
    pointer tmp;

    node = new_node();
    q->nodes[node].value = val;
    tmp = atomic_load_explicit(&q->nodes[node].next, relaxed);
    set_ptr(&tmp, 0); // NULL
    atomic_store_explicit(&q->nodes[node].next, tmp, relaxed);

    while (!success) {
        tail = atomic_load_explicit(&q->tail, acquire);
        next = atomic_load_explicit(&q->nodes[get_ptr(tail)].next, acquire);
        if (tail == atomic_load_explicit(&q->tail, relaxed)) {

            /* Check for uninitialized 'next' */
            assert(get_ptr(next) != POISON_IDX);

            if (get_ptr(next) == 0) { // == NULL
                pointer value = MAKE_POINTER(node, get_count(next) + 1);
                success = atomic_compare_exchange_strong_explicit(&q->nodes[get_ptr(tail)].next,
                        &next, value, release, release);
            }
            if (!success) {
                unsigned int ptr = get_ptr(atomic_load_explicit(&q->nodes[get_ptr(tail)].next, acquire));
                pointer value = MAKE_POINTER(ptr,
                        get_count(tail) + 1);
                atomic_compare_exchange_strong_explicit(&q->tail,
                        &tail, value,
                        release, release);
//                thrd_yield();
            }
        }
    }
    atomic_compare_exchange_strong_explicit(&q->tail,
            &tail,
            MAKE_POINTER(node, get_count(tail) + 1),
            release, release);
}

bool dequeue(queue_t *q, unsigned int *retVal)
{
    int success = 0;
    pointer head;
    pointer tail;
    pointer next;

    while (!success) {
        head = atomic_load_explicit(&q->head, acquire);
        tail = atomic_load_explicit(&q->tail, relaxed);
        next = atomic_load_explicit(&q->nodes[get_ptr(head)].next, acquire);
        if (atomic_load_explicit(&q->head, relaxed) == head) {
            if (get_ptr(head) == get_ptr(tail)) {

                /* Check for uninitialized 'next' */
                assert(get_ptr(next) != POISON_IDX);

                if (get_ptr(next) == 0) { // NULL
                    return false; // NULL
                }
                atomic_compare_exchange_strong_explicit(&q->tail,
                        &tail,
                        MAKE_POINTER(get_ptr(next), get_count(tail) + 1),
                        release, release);
//                thrd_yield();
            } else {
                *retVal = q->nodes[get_ptr(next)].value;
                success = atomic_compare_exchange_strong_explicit(&q->head,
                        &head,
                        MAKE_POINTER(get_ptr(next), get_count(head) + 1),
                        release, release);
                __VERIFIER_assume(success);
                /* if (!success) */
                /*     ;//                    thrd_yield(); */
            }
        }
    }
    reclaim(get_ptr(head));
    return true;
}


// main.c
//
#define MAXREADERS 3
#define MAXWRITERS 3
#define MAXRDWR 3

#ifdef CONFIG_QUEUE_READERS
#define DEFAULT_READERS (CONFIG_QUEUE_READERS)
#else
#define DEFAULT_READERS 1
#endif

#ifdef CONFIG_QUEUE_WRITERS
#define DEFAULT_WRITERS (CONFIG_QUEUE_WRITERS)
#else
#define DEFAULT_WRITERS 1
#endif

#ifdef CONFIG_QUEUE_RDWR
#define DEFAULT_RDWR (CONFIG_QUEUE_RDWR)
#else
#define DEFAULT_RDWR 0
#endif

int readers = DEFAULT_READERS, writers = DEFAULT_WRITERS, rdwr = DEFAULT_RDWR;

static queue_t *queue;
static int num_threads;

queue_t myqueue;
int param[MAX_THREADS];
unsigned int input[MAX_THREADS];
unsigned int output[MAX_THREADS];
pthread_t threads[MAX_THREADS];

int __thread tid;

void set_thread_num(int i)
{
    tid = i;
}

int get_thread_num()
{
    return tid;
}

bool succ[MAX_THREADS];

void *threadW(void *param)
{
    unsigned int val;
    int pid = *((int *)param);

    set_thread_num(pid);

    input[pid] = pid * 10;
    enqueue(queue, input[pid]);
//    succ[pid] = dequeue(queue, &output[pid]);
    //printf("Dequeue: %d\n", output[0]);
    return NULL;
}

void *threadR(void *param)
{
    unsigned int val;
    int pid = *((int *)param);

    set_thread_num(pid);

//    input[pid] = pid * 10;
//    enqueue(queue, input[pid]);
    succ[pid] = dequeue(queue, &output[pid]);
    //printf("Dequeue: %d\n", output[0]);
    return NULL;
}

void *threadRW(void *param)
{
    unsigned int val;
    int pid = *((int *)param);

    set_thread_num(pid);

    input[pid] = pid * 10;
    enqueue(queue, input[pid]);
    succ[pid] = dequeue(queue, &output[pid]);
    //printf("Dequeue: %d\n", output[0]);
    return NULL;
}


// variant
//
int main()
{
    int i = 0;
    unsigned int in_sum = 0, out_sum = 0;

    queue = &myqueue;
    num_threads = readers + writers + rdwr;

    init_queue(queue, num_threads);
    
    param[0] = 0;
    param[1] = 1;
    
    pthread_create(&threads[0], NULL, threadW, &param[0]);
    
    pthread_create(&threads[0], NULL, threadR, &param[0]);
    
    return 0;
}
