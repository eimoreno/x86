/* fltarith.c    show some simple C code and corresponding nasm code */
#include <stdio.h>
int main()
{ 
  double a=3.0, b=4.0, c;

  c=5.0;
  printf("%s, a=%e, b=%e, c=%e\n","c=5.0", a, b, c);
  c=a+b;
  printf("%s, a=%e, b=%e, c=%e\n","c=a+b", a, b, c);
  c=a-b;
  printf("%s, a=%e, b=%e, c=%e\n","c=a-b", a, b, c);
  c=a*b;
  printf("%s, a=%e, b=%e, c=%e\n","c=a*b", a, b, c);
  c=c/a;
  printf("%s, a=%e, b=%e, c=%e\n","c=c/a", a, b, c);
  return 0;
}
