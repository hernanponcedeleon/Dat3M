#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>
#include <stdlib.h>

#include <limits.h>
#include <stdbool.h>
#include <stdint.h>

// The following code is an adaptation from https://github.com/jserv/concurrent-ll

// list.h

/* interface for the list */

typedef intptr_t val_t;

typedef struct node node_t;
typedef struct list list_t;

/* return 0 if not found, positive number otherwise */
list_t *list_new();

/* return true if value already in the list */
bool list_contains(list_t *the_list, val_t val);

/* insert a new node with the given value val in the list.
 * @return true if succeed
 */
bool list_add(list_t *the_list, val_t val);

/* delete a node with the given value val (if the value is present).
 * @return true if succeed
 */
bool list_remove(list_t *the_list, val_t val);

void list_delete(list_t *the_list);
int list_size(list_t *the_list);

// list.c

struct node {
    val_t data;
    _Atomic(struct node*) next;
};

struct list {
    node_t *head, *tail;
    atomic_int size;
};

/* The following functions handle the low-order mark bit that indicates
 * whether a node is logically deleted (1) or not (0).
 *  - is_marked_ref returns whether it is marked,
 *  - (un)set_marked changes the mark,
 *  - get_(un)marked_ref sets the mark before returning the node.
 */
static inline bool is_marked_ref(void *i)
{
    return (bool) ((uintptr_t) i & 0x1L);
}

static inline void *get_unmarked_ref(void *w)
{
    return (void *) ((uintptr_t) w & ~0x1L);
}

static inline void *get_marked_ref(void *w)
{
    return (void *) ((uintptr_t) w | 0x1L);
}

/* list_search looks for value val, it
 *  - returns right_node owning val (if present) or its immediately higher
 *    value present in the list (otherwise) and
 *  - sets the left_node to the node owning the value immediately lower than
 *    val.
 * Encountered nodes that are marked as logically deleted are physically removed
 * from the list, yet not garbage collected.
 */
static node_t *list_search(list_t *set, val_t val, node_t **left_node)
{
    node_t *left_node_next, *right_node;
    left_node_next = right_node = NULL;
    while (1) {
        node_t *t = set->head;
        node_t *t_next = set->head->next;
        while (is_marked_ref(t_next) || (t->data < val)) {
            if (!is_marked_ref(t_next)) {
                (*left_node) = t;
                left_node_next = t_next;
            }
            t = get_unmarked_ref(t_next);
            if (t == set->tail) {
                break;
            }
            t_next = t->next;
        }
        right_node = t;

        if (left_node_next == right_node) {
            if (!is_marked_ref(right_node->next)) {
                return right_node;
            }
        } else {
            if (atomic_compare_exchange_strong_explicit(&((*left_node)->next), &left_node_next, right_node, memory_order_seq_cst, memory_order_seq_cst)) {
                if (!is_marked_ref(right_node->next)) {
                    return right_node;
                }
            }
        }
    }
}

/* return true if there is a node in the list owning value val. */
bool list_contains(list_t *the_list, val_t val)
{
    node_t *iterator = get_unmarked_ref(the_list->head->next);
    while (iterator != the_list->tail) {
        if (!is_marked_ref(iterator->next) && iterator->data >= val) {
            /* either we found it, or found the first larger element */
            return iterator->data == val;
        }

        /* always get unmarked pointer */
        iterator = get_unmarked_ref(iterator->next);
    }
    return false;
}

static node_t *new_node(val_t val, node_t *next)
{
    node_t *node = malloc(sizeof(node_t));
    node->data = val;
    node->next = next;
    return node;
}

list_t *list_new()
{
    /* allocate list */
    list_t *the_list = malloc(sizeof(list_t));

    /* now need to create the sentinel node */
    the_list->head = new_node(INT_MIN, NULL);
    the_list->tail = new_node(INT_MAX, NULL);
    the_list->head->next = the_list->tail;
    the_list->size = 0;
    return the_list;
}

void list_delete(list_t *the_list)
{
    /* FIXME: implement the deletion */
}

int list_size(list_t *the_list)
{
    return the_list->size;
}

bool list_add(list_t *the_list, val_t val)
{
    node_t *left = NULL;
    node_t *new_elem = new_node(val, NULL);
    while (1) {
        node_t *right = list_search(the_list, val, &left);
        if (right != the_list->tail && right->data == val) {
            return false;
        }

        new_elem->next = right;
        if (atomic_compare_exchange_strong_explicit(&(left->next), &right, new_elem, memory_order_seq_cst, memory_order_seq_cst)) {
            atomic_fetch_add_explicit(&(the_list->size), 1, memory_order_seq_cst);
            return true;
        }
    }
}

/* The deletion is logical and consists of setting the node mark bit to 1. */
bool list_remove(list_t *the_list, val_t val)
{
    node_t *left = NULL;
    while (1) {
        node_t *right = list_search(the_list, val, &left);
        /* check if we found our node */
        if ((right == the_list->tail) || (right->data != val)) {
            return false;
        }

        node_t *right_succ = right->next;
        if (!is_marked_ref(right_succ)) {
            if (atomic_compare_exchange_strong_explicit(&(right->next), &right_succ,
                        get_marked_ref(right_succ), memory_order_seq_cst, memory_order_seq_cst)) {
                atomic_fetch_sub_explicit(&(the_list->size), 1, memory_order_seq_cst);
                return true;
            }
        }
    }
}


static list_t *the_list;

void *thread_n(void *arg)
{
    intptr_t index = ((intptr_t) arg);

    list_add(the_list, index);
    assert(list_contains(the_list, index));
    list_remove(the_list, index);
    assert(!list_contains(the_list, index));

    return NULL;
}

int main()
{
    pthread_t t1, t2, t3;

    /* initialization of the list */
    the_list = list_new();

    pthread_create(&t1, NULL, thread_n, (void *) 0);
    pthread_create(&t2, NULL, thread_n, (void *) 1);
    pthread_create(&t3, NULL, thread_n, (void *) 2);
    
    pthread_join(t1, 0);
    pthread_join(t2, 0);
    pthread_join(t3, 0);
    
    assert(list_size(the_list) == 0);
    
    return 0;
}

