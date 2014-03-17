/////////////////
//IT IS HIGHLY SUGGESTED THAT THIS FILE IS IN A PRECOMPILED HEADER
/////////////////

#pragma once
/////////////////
//Some Default Includes
#include <iostream>

//C++11
#include <unordered_map>
#include <atomic>

/////////////////
//WARNING SUPRESSIONS
#if defined( _WIN32 )
#define _CRT_SECURE_NO_WARNINGS
#endif

#include <string>
typedef std::string istring;

/////////////////
//ASSERTIONS
#include <cassert>

#ifdef _USE_CONTROL_ADV_ASSERT_
#ifdef _DEBUG
#define assertion(x) \
{ \
  if(!(x)) \
  { \
    std::cout << "Assert " << __FILE__ << ":" << __LINE__ << "(" << #x << ")\n"; \
    __debugbreak(); \
  } \
}
#else
#define assertion(x) {}
#endif//_DEBUG
#else
#define assertion(x) assert(x)
#endif //_USE_CONTROL_ADV_ASSERT_

/////////////////
//SUPER HELPFUL FOR VS TODO OUTPUT
#define STRINGIZE_(X) #X
#define STRINGIZE(X) STRINGIZE_(X)
#define TODO(X) \
  __pragma(message(__FILE__ "(" STRINGIZE(__LINE__) "): TODO_" X))

/////////////////
//DEFAULT TYPE DEFINITIONS
#include <stdint.h>

typedef char      c08;

typedef int8_t    s08;
typedef uint8_t   u08;

typedef int16_t   s16;
typedef uint16_t  u16;

typedef int32_t   s32;
typedef uint32_t  u32;

typedef int64_t   s64;
typedef uint64_t  u64;

typedef float     f32;
typedef double    f64;

/////////////////
//WRAPPERS FOR CASTS
#define DYNCAST(newClass, var) dynamic_cast<newClass>(var)
#define RECAST(newClass, var) reinterpret_cast<newClass>(var)
#define SCAST(newType, var) static_cast<newType>(var)
