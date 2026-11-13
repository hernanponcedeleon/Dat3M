/*
    argv points to an array of argc + 1 pointers whose last entry is NULL (C11 5.1.2.2.1).
    argc may be 0, in which case argv[0] is NULL.
    The strings argv[0..argc-1] are not modeled, so their values are unconstrained.
    Compile with -fsanitize=null to check that accesses to argv within argc are valid.

    Expected verdicts:
      default:     PASS
      -DFAIL:      FAIL (argv[0] may be any pointer)
      -DZERO:      FAIL (argc may be 0)
*/

extern void __assert_fail(const char *, const char *, unsigned int, const char *);
void reach_error() { __assert_fail("0", "main-args.c", 13, "reach_error"); }

int main(int argc, char *argv[]) {
    if (argc == 3) {
        char *a = argv[1];
        char *b = argv[2];
        if (a == b) {
            return 1;
        }
    }
#if defined(FAIL)
    if (argv[0] == 0) reach_error();
#elif defined(ZERO)
    if (argc == 0) reach_error();
#else
    if (argc < 0 || argv[argc] != 0) reach_error();
#endif
    return 0;
}
