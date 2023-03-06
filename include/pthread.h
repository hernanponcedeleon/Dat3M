typedef unsigned long int pthread_t;
typedef unsigned long int pthread_attr_t;
typedef unsigned long int pthread_mutex_t;
typedef unsigned long int pthread_mutexattr_t;

int pthread_create(pthread_t *restrict thread,
                          const pthread_attr_t *restrict attr,
                          void *(*start_routine)(void *),
                          void *restrict arg);
extern int pthread_join(pthread_t thread, void **retval);

#ifdef USE_PTHREAD_MUTEX_IMPLEMENTATION
#include<stdatomic.h>
#define pthread_mutex_t atomic_int
int pthread_mutex_lock(pthread_mutex_t *mutex) {
    while(atomic_compare_exchange_strong_explicit(mutex, 0, 1, memory_order_acquire, memory_order_acquire));
    return 0;
}
int pthread_mutex_unlock(pthread_mutex_t *mutex) {
    atomic_store_explicit(mutex, 0, memory_order_release);
    return 0;
}
int pthread_mutex_init(pthread_mutex_t *restrict mutex, const pthread_mutexattr_t *restrict attr) {
    atomic_store_explicit(mutex, 0, memory_order_release);
    return 0;
}
#else
extern int pthread_mutex_lock(pthread_mutex_t *mutex);
extern int pthread_mutex_unlock(pthread_mutex_t *mutex);
extern int pthread_mutex_init(pthread_mutex_t *restrict mutex, const pthread_mutexattr_t *restrict attr);
#endif