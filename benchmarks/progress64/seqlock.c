#include <assert.h>
#include <pthread.h>
#include "p64_rwsync.c"

typedef struct {
    int x;
    int y;
} shared_data_t;

p64_rwsync_t sync;
shared_data_t data;

void *writer(void *arg) {
    p64_rwsync_acquire_wr(&sync);
    data.x++;
    data.y++;
    p64_rwsync_release_wr(&sync);
    return NULL;
}

void *reader(void *arg) {
    shared_data_t local;
    p64_rwsync_read(&sync, &local, &data, sizeof(local));
    return NULL;
}

int main(void) {
    pthread_t writers[2], readers[2];
    p64_rwsync_init(&sync);
    data.x = 0;
    data.y = 0;

    for (int i = 0; i < 2; i++) {
        if (pthread_create(&writers[i], NULL, writer, NULL) != 0) {
            exit(EXIT_FAILURE);
        }
    }
    for (int i = 0; i < 2; i++) {
        if (pthread_create(&readers[i], NULL, reader, NULL) != 0) {
            exit(EXIT_FAILURE);
        }
    }

    for (int i = 0; i < 2; i++) {
        if (pthread_join(writers[i], NULL) != 0) {
            exit(EXIT_FAILURE);
        }
    }

    for (int i = 0; i < 2; i++) {
        if (pthread_join(readers[i], NULL) != 0) {
            exit(EXIT_FAILURE);
        }
    }
    assert(data.x == 2 && data.y == 2);
    return 0;
}