#include <stdint.h>
#include <dat3m.h>


int main()
{
    int x = __VERIFIER_nondet_int();
head:
    if(x == 0) {
	    return 0;
    }
    if(x < 0) {
        x++;
        goto head;
    } else {
        x--;
        goto head;
    }
}
