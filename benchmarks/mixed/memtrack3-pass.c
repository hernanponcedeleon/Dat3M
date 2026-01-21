#include <stdlib.h>
int* volatile m_global;
int main()
{
  m_global = (int*) malloc(sizeof(int));
  int* temp = m_global;
  *((char volatile*) &m_global) = '\0';
  free(temp);
  return 0;
}
