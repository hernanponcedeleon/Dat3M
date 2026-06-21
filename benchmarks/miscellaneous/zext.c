#include <assert.h>
#include <stdlib.h>

unsigned int n = 3435973837;

int main() {
  assert (!(n < (4294967296 / 5)));
  return 0;
}