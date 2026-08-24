/**
 * Provides a function to read strings from a file.
 *
 * @author  T.Sergeant
 * @version For Assembly HW
 *
 */

#include<stdio.h>
#include<stdlib.h>
#define MAXSTR 27

int readStrings(char a[][MAXSTR], char filename[])
{
	FILE * fp;
	int n;

	n= 0;
	fp= fopen(filename,"r");
  	while (fgets(a[n],MAXSTR,fp)!=NULL) {
		printf("%s",a[n]);
		n++;
	}
	fclose(fp);

	return n;
}
