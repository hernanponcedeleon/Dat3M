#pragma once
#if defined(__arm__) && !defined(__aarch64__)
typedef unsigned int size_t;
#else
typedef unsigned long size_t;
#endif
