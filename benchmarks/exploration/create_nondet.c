#include <pthread.h>
#include <stdatomic.h>
#include <assert.h>

// The number of created threads depends on a value read at run time: the creating loop runs once or twice.
// Each thread instance has its own thread id (pthread_self) and return value.

atomic_int flag;
atomic_int counter;
pthread_t self[2];

void *worker(void *arg) {
    atomic_fetch_add_explicit(&counter, 1, memory_order_relaxed);
    *(pthread_t *) arg = pthread_self();
    return arg;
}

void *setter(void *arg) {
    atomic_store_explicit(&flag, 1, memory_order_relaxed);
    return NULL;
}

int main() {
    pthread_t s, t[2];
    pthread_create(&s, NULL, setter, NULL);
    int n = 1 + atomic_load_explicit(&flag, memory_order_relaxed);
    for (int i = 0; i < n; i++) {
        pthread_create(&t[i], NULL, worker, &self[i]);
    }
    for (int i = 0; i < n; i++) {
        void *ret;
        pthread_join(t[i], &ret);
        assert(ret == &self[i]);
        assert(self[i] == t[i]);
    }
    pthread_join(s, NULL);
    assert(atomic_load_explicit(&counter, memory_order_relaxed) == n);
    return 0;
}
