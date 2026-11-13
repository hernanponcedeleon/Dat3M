#include <pthread.h>
#include <stdbool.h>
#include <assert.h>

/*
    pthread_create stores the id of the spawned thread before the thread starts (as in glibc).
    Thus, a thread that synchronizes with the spawned thread observes the stored id and can join with it.
    EXPECTED: PASS
*/

// Initialized to an invalid id, so joining with a stale value fails (0 would be the id of main).
pthread_t worker_tid = (pthread_t) 42;
bool done = false;
pthread_mutex_t mutex;

void *worker(void *arg)
{
    pthread_mutex_lock(&mutex);
    done = true;
    pthread_mutex_unlock(&mutex);
    return NULL;
}

void *cleaner(void *arg)
{
    pthread_mutex_lock(&mutex);
    if (done) {
        // Synchronizes with the worker via the mutex, so worker_tid must be visible.
        int status = pthread_join(worker_tid, NULL);
        assert(status == 0);
    }
    pthread_mutex_unlock(&mutex);
    return NULL;
}

int main()
{
    // NOTE: We do not use PTHREAD_MUTEX_INITIALIZER, as it is not supported for macOS.
    pthread_mutex_init(&mutex, NULL);
    pthread_t cleaner_tid;
    pthread_create(&cleaner_tid, NULL, cleaner, NULL);
    pthread_create(&worker_tid, NULL, worker, NULL);
    pthread_join(cleaner_tid, NULL);
    return 0;
}
