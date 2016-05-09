/* printf2.c  coded as  printf2.asm  for nasm                    */
/*   gcc printf2.c                                               */
/*   a.out                                                       */
/* Hello world: a string 1234567 6789ABCD 5.327000e-30 -1.234000E+302 */


#include <stdio.h>
int main()
{
  char   char1='a';         /* sample character */
  char   str1[]="string";   /* sample string */
  int    int1=1234567;      /* sample integer */
  int    hex1=0x6789ABCD;   /* sample hexadecimal */
  float  flt1=5.327e-30;    /* sample float */
  double flt2=-123.4e300;   /* sample double */

  printf("Hello world: %c %s %d %X %e %E \n", /* format string for printf */
         char1, str1, int1, hex1, flt1, flt2);
  return 0;
}
