#pragma once
#include <_size_t.h>

#define EXIT_SUCCESS ((int)0)
#define EXIT_FAILURE ((int)1)
[[noreturn]] void exit(int);

void free(void *);
void * malloc(size_t);
