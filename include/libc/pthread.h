#pragma once
typedef void* pthread_t;
typedef void* pthread_attr_t;
int pthread_create(pthread_t*,pthread_attr_t const*,void*(*)(void*),void*);
int pthread_join(pthread_t,void**);
