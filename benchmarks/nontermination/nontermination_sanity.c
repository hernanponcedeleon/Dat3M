#include <pthread.h>
#include <stdatomic.h>

/*
    Test case: Special case to ensure that Dartagnan's internal optimization pipeline does not hide side-effects:
               Naively, unrolling the loop k < 10 times and performing SCCP results in k empty iteration bodies,
               which looks identical to a k-times unrolled while(1)-loop.
               However, the insufficiently unrolled loop will terminate, the while(1)-loop will not and
               so need to be distinguished somehow (e.g. by instrumentation).
*/

int main()
{
    int i = 0;
    while(!(i > 10)) {
        i++;
    }

    return 0;
}