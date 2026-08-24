/**
 * Provides a function to read strings from a file.
 *
 * @author  T.Sergeant
 * @version For AL Homework
 *
 */

#include<stdio.h>
#include<stdlib.h>
#include<string.h>

struct Code {
	int id;
	int score;
	char description[256];
};


int readCodes(struct Code *a[], char filename[])
{
	FILE * fp;
	int n, id, score;

	n= 0;
	fp= fopen(filename,"r");
  	while (fscanf(fp,"%d %d ",&id,&score) > 0) {
		a[n]= (struct Code *) malloc(sizeof(struct Code));
		a[n]->id= id;
		a[n]->score= score;
  		fgets(a[n]->description,256,fp);
		(a[n]->description)[strlen(a[n]->description)-1]= '\0'; // toss out \n
		n++;
	}
	fclose(fp);

	return n;
}
