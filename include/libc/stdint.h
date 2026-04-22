#pragma once
#define INT8_MAX ((int8_t)0x7f)
#define INT16_MAX ((int16_t)0x7fff)
#define INT32_MAX ((int32_t)0x7fffffff)
#define INT64_MAX ((int64_t)0x7fffffffffffffff)
#define UINT8_MAX ((uint8_t)-1)
#define UINT16_MAX ((uint16_t)-1)
#define UINT32_MAX ((uint32_t)-1)
#define UINT64_MAX ((uint64_t)-1)
typedef signed char int8_t;
typedef signed short int16_t;
typedef signed int int32_t;
typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;
#if defined(__arm__) && !defined(__aarch64__)
typedef signed int intptr_t;
typedef signed long long int64_t;
typedef unsigned int uintptr_t;
typedef unsigned long long uint64_t;
#else
typedef signed long int64_t;
typedef signed long intptr_t;
typedef unsigned long uint64_t;
typedef unsigned long uintptr_t;
#endif
