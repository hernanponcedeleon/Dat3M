#pragma once
void __assert_fail(char const*,char const*,int,char const*);
#define assert(x) ({if(!(x))__assert_fail(#x,__FILE__,__LINE__,__func__);})
