#include <pthread.h>
#include <safe_stack.h>
#include <assert.h>

void *thread3(void *arg)
{
    intptr_t idx = ((intptr_t) arg);

    int elem;
    while (elem = pop() < 0) {}
    atomic_store_explicit(&array[elem].value, idx, memory_order_relaxed);
    assert (atomic_load_explicit(&array[elem].value, memory_order_relaxed) == idx);
    push(elem);

    while (pop() < 0) {}
    atomic_store_explicit(&array[elem].value, idx, memory_order_relaxed);
    assert (atomic_load_explicit(&array[elem].value, memory_order_relaxed) == idx);
    return NULL;
}

void *thread1(void *arg)
{
    intptr_t idx = ((intptr_t) arg);

    while (pop() < 0) {}
    return NULL;
}

int main()
{
    pthread_t t0, t1, t2;

    init();
    
    pthread_create(&t0, NULL, thread3, (void *) 0);
    pthread_create(&t1, NULL, thread3, (void *) 1);
    pthread_create(&t2, NULL, thread1, (void *) 2);

    return 0;
}
