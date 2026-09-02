/**
 * Provides a function that does the same action as calc2 in regdemo2.asm.
 *
 * @author  T.Sergeant
 * @version Fall 2016
 *
 */

#include<stdio.h>
#include<stdlib.h>

long mycalc(long a, long b, long c, long d, long e, long f, long g, long h)
{
	return (a+b*c+d) - (e+f*g+h);
}
