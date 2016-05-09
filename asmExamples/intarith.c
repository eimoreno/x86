/* intarith.c    show some intarith C code and corresponding nasm code
 *
 * compile/link: gcc intarith.c
 * run:          a.out
 */
#include <stdio.h>
int main()
{ 
  int a=3, b=4, c;
  c=5;
  printf("%s, a=%d, b=%d, c=%d\n","c=5  ", a, b, c);
  c=a+b;
  printf("%s, a=%d, b=%d, c=%d\n","c=a+b", a, b, c);
  c=a-b;
  printf("%s, a=%d, b=%d, c=%d\n","c=a-b", a, b, c);
  c=a*b;
  printf("%s, a=%d, b=%d, c=%d\n","c=a*b", a, b, c);
  c=c/a;
  printf("%s, a=%d, b=%d, c=%d\n","c=c/a", a, b, c);
  return 0;
}
