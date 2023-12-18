#include <stdio.h>
#include <assert.h>
#include <pthread.h>

/*
    The test checks if function pointers in static memory are handled correctly.
    Expected result: PASS
*/

typedef struct {
   void* (*funcPtrOne) (void*);
   void* (*funcPtrTwo) (void*);
} MyPtrStruct;

int callCounter = 0;

void *myFunc1(void* arg) {
    assert (arg == 1);
    return NULL;
}

void *myFunc2(void* arg) {
    assert (arg == 42 || arg == 123);
    callCounter++;
    return arg;
}

MyPtrStruct myStruct = { myFunc1, myFunc2 };

int main () {
   assert(myStruct.funcPtrOne(1) == NULL);
   assert(myStruct.funcPtrTwo(42) == 42);

   pthread_t t;
   pthread_create(&t, NULL, myStruct.funcPtrTwo, (void*)123);
   pthread_join(t, NULL);
   assert (callCounter == 2);
}