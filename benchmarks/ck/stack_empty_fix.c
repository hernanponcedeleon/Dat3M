#include <pthread.h>
#include <stdlib.h>
#include <ck_stack.h>
#include <assert.h>

#ifndef NUM_PUSH_PER_THREAD
#define NUM_PUSH_PER_THREAD 2
#endif

#ifndef NUM_PUSHERS
#define NUM_PUSHERS 1
#endif

#ifndef NUM_POPPERS
#define NUM_POPPERS 2
#endif

ck_stack_t stack = CK_STACK_INITIALIZER;

void *pusher_fn(void *arg)
{
    for (int i = 0; i < NUM_PUSH_PER_THREAD; i++)
    {
        ck_stack_entry_t *entry = malloc(sizeof(ck_stack_entry_t));
        if (!entry)
        {
            exit(EXIT_FAILURE);
        }
        ck_stack_push_upmc(&stack, entry);
    }
    return NULL;
}

void *popper_fn(void *arg)
{
    ck_stack_entry_t *entry;
    // while((entry = ck_stack_pop_upmc(&stack)) == NULL);
    // let's try to make it more explicit for dat3m
    for (;;) {
        entry = ck_stack_pop_upmc(&stack);
        if (entry != NULL) {
            break;
        }
    }
    free(entry);
    return NULL;
}

int main(void)
{
    pthread_t pushers[NUM_PUSHERS];
    pthread_t poppers[NUM_POPPERS];

    for (int i = 0; i < NUM_PUSHERS; i++)
    {
        if (pthread_create(&pushers[i], NULL, pusher_fn, NULL) != 0)
        {
            return EXIT_FAILURE;
        }
    }

    for (int i = 0; i < NUM_POPPERS; i++)
    {
        if (pthread_create(&poppers[i], NULL, popper_fn, NULL) != 0)
        {
            return EXIT_FAILURE;
        }
    }

    for (int i = 0; i < NUM_PUSHERS; i++)
    {
        pthread_join(pushers[i], NULL);
    }

    for (int i = 0; i < NUM_POPPERS; i++)
    {
        pthread_join(poppers[i], NULL);
    }

    assert(CK_STACK_ISEMPTY(&stack));

    return EXIT_SUCCESS;
}