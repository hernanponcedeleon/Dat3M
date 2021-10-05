extern void __assert_fail(const char *__assertion, const char *__file, unsigned int __line, const char *__function);
#define assert(x) (x?(void)0:__assert_fail("","",0,""))
