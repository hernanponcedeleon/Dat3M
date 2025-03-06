#include <pthread.h>
#include <stdlib.h>
#include <ck_stack.h>
#include <assert.h>
#include <dat3m.h>

#define NUM_PUSH_PER_THREAD 3
#define NUM_PUSHERS 2
#define NUM_POPPERS 2

ck_stack_t stack = CK_STACK_INITIALIZER;
int pusher_done = 0;
pthread_mutex_t done_mutex = PTHREAD_MUTEX_INITIALIZER;
int pushers_finished = 0;

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

    pthread_mutex_lock(&done_mutex);
    pushers_finished++;
    if (pushers_finished == NUM_PUSHERS)
    {
        ck_pr_store_int(&pusher_done, 1);
    }
    pthread_mutex_unlock(&done_mutex);

    return NULL;
}

void *popper_fn(void *arg)
{
    ck_stack_entry_t *entry;

#ifdef VERIFICATION_DAT3M
    bool res = ck_pr_load_int(&pusher_done);
    __VERIFIER_assume(res);
#else
    while (!ck_pr_load_int(&pusher_done)){}
#endif

    while ((entry = ck_stack_pop_upmc(&stack)) != NULL)
    {
        free(entry);
    }

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