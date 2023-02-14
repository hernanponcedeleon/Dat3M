/********************************************************
*                                                       *
*     Copyright (C) Microsoft. All rights reserved.     *
*                                                       *
********************************************************/

#include <pthread.h>
#include "wsq.h"

#define INITQSIZE 2 // must be power of 2

#define ITEMS 4
#define STEALERS 2
#define STEAL_ATTEMPS 1

void *stealer(void *unused) {
    Obj *r;
    for (int i = 0; i < STEAL_ATTEMPS; i++) {
        if (steal(&r)) {
            operation(r);
        }
    }
    return 0;
}

Obj items[ITEMS];

int main(void) {
    pthread_t stealers[STEALERS];

    init_WSQ(INITQSIZE);

    for (int i = 0; i < ITEMS; i++) {
        init_Obj(&items[i]);
    }

    for (int i = 0; i < STEALERS; i++) {
        pthread_create(&stealers[i], NULL, stealer, 0);
    }

    for (int i = 0; i < ITEMS / 2; i++) {
        push(&items[2 * i]);
        push(&items[2 * i + 1]);
        Obj *r;
        if (pop(&r)) {
            operation(r);
        }
    }

    for (int i = 0; i < ITEMS / 2; i++) {
        Obj *r;
        if (pop(&r)) {
            operation(r);
        }
    }

    for (int i = 0; i < STEALERS; i++) {
        pthread_join(stealers[i], NULL);
    }

    for (int i = 0; i < ITEMS; i++) {
        check(&items[i]);
    }

    return 0;
}
