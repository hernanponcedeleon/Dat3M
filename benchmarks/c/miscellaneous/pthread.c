#include <pthread.h>
#include <assert.h>
#include <stdbool.h>
#include <dat3m.h>

// Test basic support for the pthread library.
// Library symbols can be recognized by the `pthread_` prefix.
// TODO Preprocessor constants cannot be as easily recognized and could be platform-dependent.

// -------- Threads

pthread_t thread_create(void*(*runner)(void*), void* data)
{
    pthread_t id;
    pthread_attr_t attr;
    pthread_attr_init(&attr);
    int status = pthread_create(&id, &attr, runner, data);
    assert(status == 0);
    pthread_attr_destroy(&attr);
    return id;
}

void* thread_join(pthread_t id)
{
    void* result;
    int status = pthread_join(id, &result);
    assert(status == 0);
    return result;
}

// -------- Mutual exclusion

//from pthread.h for darwin:
//define PTHREAD_MUTEX_NORMAL 0
//define PTHREAD_MUTEX_ERRORCHECK 1
//define PTHREAD_MUTEX_RECURSIVE 2
//define PTHREAD_MUTEX_DEFAULT PTHREAD_MUTEX_NORMAL
//define PTHREAD_PRIO_NONE 0
//define PTHREAD_PRIO_INHERIT 1
//define PTHREAD_PRIO_PROTECT 2
//define PTHREAD_MUTEX_POLICY_FAIRSHARE_NP 1
//define PTHREAD_MUTEX_POLICY_FIRSTFIT_NP 3
void mutex_init(pthread_mutex_t* lock, int type, int protocol, int policy, int prioceiling)
{
    int status;
    int value;
    pthread_mutexattr_t attributes;
    status = pthread_mutexattr_init(&attributes);
    assert(status == 0);

    status = pthread_mutexattr_settype(&attributes, type);
    assert(status == 0);
    status = pthread_mutexattr_gettype(&attributes, &value);
    assert(status == 0);// && value == type); TODO Add storage of attribute entries.

    status = pthread_mutexattr_setprotocol(&attributes, protocol);
    assert(status == 0);
    status = pthread_mutexattr_getprotocol(&attributes, &value);
    assert(status == 0);// && value == protocol);

    status = pthread_mutexattr_setpolicy_np(&attributes, policy);
    assert(status == 0);
    status = pthread_mutexattr_getpolicy_np(&attributes, &value);
    assert(status == 0);// && value == policy);

    status = pthread_mutexattr_setprioceiling(&attributes, prioceiling);
    assert(status == 0);
    status = pthread_mutexattr_getprioceiling(&attributes, &value);
    assert(status == 0);// && value == prioceiling);

    status = pthread_mutex_init(lock, &attributes);
    assert(status == 0);
    status = pthread_mutexattr_destroy(&attributes);
    assert(status == 0);
}

void mutex_destroy(pthread_mutex_t* lock)
{
    int status = pthread_mutex_destroy(lock);
    assert(status == 0);
}

void mutex_lock(pthread_mutex_t* lock)
{
    int status = pthread_mutex_lock(lock);
    assert(status == 0);
}

bool mutex_trylock(pthread_mutex_t* lock)
{
    int status = pthread_mutex_trylock(lock);
    //assert(status == 0 || status == EBUSY); // TODO Add support for platform-dependent error codes.
    return status == 0;
}

void mutex_unlock(pthread_mutex_t* lock)
{
    int status = pthread_mutex_unlock(lock);
    assert(status == 0);
}

void mutex_test()
{
    pthread_mutex_t mutex0;
    pthread_mutex_t mutex1;
    //TODO Add different behavior based on attributes.
    mutex_init(&mutex0, PTHREAD_MUTEX_ERRORCHECK, PTHREAD_PRIO_INHERIT, PTHREAD_MUTEX_POLICY_FAIRSHARE_NP, 1);
    mutex_init(&mutex1, PTHREAD_MUTEX_RECURSIVE, PTHREAD_PRIO_PROTECT, PTHREAD_MUTEX_POLICY_FIRSTFIT_NP, 2);

    {
        mutex_lock(&mutex0);
        bool success = mutex_trylock(&mutex0);
        assert(!success);
        mutex_unlock(&mutex0);
    }

    {
        mutex_lock(&mutex1);

        {
            bool success = mutex_trylock(&mutex0);
            assert(success);
            mutex_unlock(&mutex0);
        }

        {
            bool success = mutex_trylock(&mutex0);
            assert(success);
            mutex_unlock(&mutex0);
        }

        /*{
            //TODO Add support for recursive mutexes.
            bool success = mutex_trylock(&mutex1);
            assert(success);
            mutex_unlock(&mutex1);
        }*/

        mutex_unlock(&mutex1);
    }

    mutex_destroy(&mutex1);
    mutex_destroy(&mutex0);
}

// -------- condition variables

void cond_init(pthread_cond_t* cond)
{
    int status;
    pthread_condattr_t attr;

    status = pthread_condattr_init(&attr);
    assert(status == 0);

    status = pthread_cond_init(cond, &attr);
    assert(status == 0);

    status = pthread_condattr_destroy(&attr);
    assert(status == 0);
}

void cond_destroy(pthread_cond_t* cond)
{
    int status = pthread_cond_destroy(cond);
    assert(status == 0);
}

void cond_signal(pthread_cond_t* cond)
{
    int status = pthread_cond_signal(cond);
    assert(status == 0);
}

void cond_broadcast(pthread_cond_t* cond)
{
    int status = pthread_cond_broadcast(cond);
    assert(status == 0);
}

void cond_wait(pthread_cond_t* cond, pthread_mutex_t* lock)
{
    int status = pthread_cond_wait(cond, lock);
    //assert(status == 0); // cannot distinguish signals from spontaneous wakes
}

void cond_timedwait(pthread_cond_t* cond, pthread_mutex_t* lock, long long millis)
{
    //see https://en.cppreference.com/w/c/chrono/timespec
    struct timespec ts;
    //timespec_get(&ts, TIME_UTC);
    //ts.tv_sec += (time_t) millis / 1000;
    //ts.tv_nsec += millis % 1000;
    (void)millis;
    int status = pthread_cond_timedwait(cond, lock, &ts);
}

pthread_mutex_t cond_mutex;
pthread_cond_t cond;
int phase = 0;

void* cond_worker(void* message)
{
    bool idle = true;
    {
        mutex_lock(&cond_mutex);
        ++phase;
        cond_wait(&cond, &cond_mutex);
        ++phase;
        idle = phase < 2;
        mutex_unlock(&cond_mutex);
    }
    if (idle)
        return ((char*) message) + 1;
    idle = true;
    {
        mutex_lock(&cond_mutex);
        ++phase;
        cond_timedwait(&cond, &cond_mutex, 10L);
        ++phase;
        idle = phase > 6;
        mutex_unlock(&cond_mutex);
    }
    if (idle)
        return ((char*) message) + 2;
    return message;
}

void cond_test()
{
    void* message = (void*) 42;
    mutex_init(&cond_mutex, PTHREAD_MUTEX_NORMAL, PTHREAD_PRIO_NONE, PTHREAD_MUTEX_POLICY_FIRSTFIT_NP, 0);
    cond_init(&cond);

    pthread_t worker = thread_create(cond_worker, message);

    {
        mutex_lock(&cond_mutex);
        ++phase;
        cond_signal(&cond);
        mutex_unlock(&cond_mutex);
    }

    {
        mutex_lock(&cond_mutex);
        ++phase;
        cond_broadcast(&cond);
        mutex_unlock(&cond_mutex);
    }

    void* result = thread_join(worker);
    //assert(result == message); //TODO add support for return values

    cond_destroy(&cond);
    mutex_destroy(&cond_mutex);
}

// -------- reader/writer locks

//from pthread.h for darwin:
//define PTHREAD_PROCESS_SHARED 0
//define PTHREAD_PROCESS_PRIVATE 1
void rwlock_init(pthread_rwlock_t* lock, int shared)
{
    int status;
    int value;
    pthread_rwlockattr_t attributes;
    status = pthread_rwlockattr_init(&attributes);
    assert(status == 0);

    status = pthread_rwlockattr_setpshared(&attributes, shared);
    assert(status == 0);
    status = pthread_rwlockattr_getpshared(&attributes, &value);
    assert(status == 0);// && value == shared); //TODO Add storage of attribute entries.

    status = pthread_rwlock_init(lock, &attributes);
    assert(status == 0);
    status = pthread_rwlockattr_destroy(&attributes);
    assert(status == 0);
}

void rwlock_destroy(pthread_rwlock_t* lock)
{
    int status = pthread_rwlock_destroy(lock);
    assert(status == 0);
}

void rwlock_wrlock(pthread_rwlock_t* lock)
{
    int status = pthread_rwlock_wrlock(lock);
    assert(status == 0);
}

bool rwlock_trywrlock(pthread_rwlock_t* lock)
{
    int status = pthread_rwlock_trywrlock(lock);
    //assert(status == 0 || status == EBUSY); //TODO Add support for platform-dependent error codes.
    return status == 0;
}

void rwlock_rdlock(pthread_rwlock_t* lock)
{
    int status = pthread_rwlock_rdlock(lock);
    assert(status == 0);
}

bool rwlock_tryrdlock(pthread_rwlock_t* lock)
{
    int status = pthread_rwlock_tryrdlock(lock);
    //assert(status == 0 || status == EBUSY); //TODO Add support for platform-dependent error codes.
    return status == 0;
}

void rwlock_unlock(pthread_rwlock_t* lock)
{
    int status = pthread_rwlock_unlock(lock);
    assert(status == 0);
}

void rwlock_test()
{
    pthread_rwlock_t lock;
    rwlock_init(&lock, PTHREAD_PROCESS_PRIVATE);
    int const test_depth = 4;

    {
        rwlock_wrlock(&lock);
        bool success = rwlock_trywrlock(&lock);
        assert(!success);
        success = rwlock_tryrdlock(&lock);
        assert(!success);
        rwlock_unlock(&lock);
    }

    {
        __VERIFIER_loop_bound(test_depth + 1);
        for (int i = 0; i < test_depth; i++)
        {
            bool success = rwlock_tryrdlock(&lock);
            assert(success);
        }

        {
            bool success = rwlock_trywrlock(&lock);
            assert(!success);
        }

        __VERIFIER_loop_bound(test_depth + 1);
        for (int i = 0; i < test_depth; i++) {
            rwlock_unlock(&lock);
        }
    }

    {
        rwlock_wrlock(&lock);
        bool success = rwlock_trywrlock(&lock);
        assert(!success);
        rwlock_unlock(&lock);
    }

    rwlock_destroy(&lock);
}

// -------- thread-local storage

pthread_t latest_thread;
pthread_key_t local_data;

void key_destroy(void* unused_value)
{
    latest_thread = pthread_self();
}

void* key_worker(void* message)
{
    int my_secret = 1;

    int status = pthread_setspecific(local_data, &my_secret);
    assert(status == 0);

    void* my_local_data = pthread_getspecific(local_data);
    assert(my_local_data == &my_secret);

    return message;
}

void key_test()
{
    int my_secret = 2;
    void* message = (void*) 41;
    int status;

    pthread_key_create(&local_data, key_destroy);

    pthread_t worker = thread_create(key_worker, message);

    status = pthread_setspecific(local_data, &my_secret);
    assert(status == 0);

    void* my_local_data = pthread_getspecific(local_data);
    assert(my_local_data == &my_secret);

    status = pthread_setspecific(local_data, NULL);
    assert(status == 0);

    void* result = thread_join(worker);
    //assert(result == message); //TODO add support for return values

    status = pthread_key_delete(local_data);
    assert(status == 0);

    //assert(pthread_equal(latest_thread, worker));//TODO add support for destructors
}

int main()
{
    mutex_test();
    cond_test();
    rwlock_test();
    key_test();
}