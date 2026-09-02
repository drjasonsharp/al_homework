/**
 * Implements a function to display an array of n ints.
 *
 * @author  T.Sergeant
 * @version Fall 2016
 *
 */
#include<stdio.h>

void displayNums(int a[], int n)
{
	int i;
	for (i=0; i<n; i++)
		printf("%d\n",a[i]);
}


/**
 * Finds position of the successor of val in the array a having n ints.
 *
 * @param a array of ints
 * @param n number of elements in the array
 * @param val value of element for which we are trying to find a successor
 *
 * @return index of successor of val (which is n if no successor is found)
 *
 * NOTE: The successor of val is the smallest element larger than val.
 *
 */
int findSuccPos(int a[], int n, int val)
{
	int i,sPos;

	for (sPos=0; sPos<n && a[sPos]<=val; sPos++); // move sPos to pos of 1st a[i]>val

	for (i=sPos; i<n; i++)
		if (a[i] < a[sPos] && a[i]>val)
			sPos= i;
	return sPos;
}