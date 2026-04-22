#pragma once
#include <_size_t.h>
#include <_null.h>
#if defined(__arm__) && !defined(__aarch64__)
typedef signed int ptrdiff_t;
#else
typedef signed long ptrdiff_t;
#endif
