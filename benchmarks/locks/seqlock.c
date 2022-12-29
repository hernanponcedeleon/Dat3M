#include <seqlock.h>
#include <pthread.h>
#include <assert.h>

#ifndef NREADERS
#define NREADERS 3
#endif

#define NTHREADS NREADERS + 3

seqlock_t lock;
pthread_t t[NTHREADS];

void *writer3(void *unused) {
    write(&lock, 3);
    return NULL;
}

void *writer2(void *unused) {
    write(&lock, 2);
    pthread_create(&t[NREADERS+2], NULL, writer3, NULL);
    return NULL;
}

void *writer1(void *unused) {
    write(&lock, 1);
    pthread_create(&t[NREADERS+1], NULL, writer2, NULL);
    return NULL;
}

void *reader(void *unused) {
	int r1 = read(&lock);
    int r2 = read(&lock);
    assert(r2 >= r1);
    return NULL;
}

int main() {
	
    seqlock_init(&lock);

    for (int i = 0; i < NREADERS; i++)
        pthread_create(&t[i], 0, reader, NULL);
    
    pthread_create(&t[NREADERS], NULL, writer1, NULL);

    return 0;
}
