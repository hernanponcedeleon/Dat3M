#include <assert.h>
#include <dat3m.h>
#include <stdlib.h>
#include <pthread.h>
#include <ck_fifo.h>

#define NTHREADS 2
#define VALUES_TO_ENQUEUE 3

typedef struct point_s
{
    unsigned int x;
    unsigned int y;
} point_t;

ck_fifo_spsc_t queue;

void *producer(void *arg)
{
    for (int i = 0; i < VALUES_TO_ENQUEUE; i++)
    {
        point_t *point = malloc(sizeof(point_t));
        if (point == NULL)
        {
            exit(EXIT_FAILURE);
        }

        point->x = 1;
        point->y = 1;

        ck_fifo_spsc_entry_t *entry = malloc(sizeof(ck_fifo_spsc_entry_t));
        if (entry == NULL)
        {
            free(point);
            exit(EXIT_FAILURE);
        }

        ck_fifo_spsc_enqueue(&queue, entry, point);
    }

    // Signal end of queue with NULL
    ck_fifo_spsc_entry_t *entry = malloc(sizeof(ck_fifo_spsc_entry_t));
    if (entry == NULL)
    {
        exit(EXIT_FAILURE);
    }
    ck_fifo_spsc_enqueue(&queue, entry, NULL);

    return NULL;
}
void *consumer(void *arg)
{
    point_t *point;

    for (int i = 0; i < VALUES_TO_ENQUEUE; i++)
    {
#ifdef VERIFICATION_DAT3M
        bool res = ck_fifo_spsc_dequeue(&queue, (void **)&point);
        __VERIFIER_assume(res);
#else
        while (!ck_fifo_spsc_dequeue(&queue, (void **)&point)){}
#endif

        // Validate dequeued value
        assert(point != NULL && "NULL point received");
        assert(point->x == point->y);
        assert(point->y == 1);

        free(point);
    }

    return NULL;
}

int main(void)
{
    pthread_t threads[NTHREADS];

    ck_fifo_spsc_entry_t *initial_entry = malloc(sizeof(ck_fifo_spsc_entry_t));
    if (initial_entry == NULL)
    {
        exit(EXIT_FAILURE);
    }
    ck_fifo_spsc_init(&queue, initial_entry);

    if (pthread_create(&threads[0], NULL, producer, NULL) != 0 ||
        pthread_create(&threads[1], NULL, consumer, NULL) != 0)
    {
        exit(EXIT_FAILURE);
    }

    for (int i = 0; i < NTHREADS; i++)
    {
        pthread_join(threads[i], NULL);
    }

    ck_fifo_spsc_entry_t *garbage;
    ck_fifo_spsc_deinit(&queue, &garbage);
    free(garbage);

    return 0;
}
