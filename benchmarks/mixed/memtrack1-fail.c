#include <stdlib.h>
int* volatile m_global;
int main()
{
  m_global = (int*) malloc(sizeof(int));
  *((char volatile*) &m_global) = '\0';
  return 0;
}
