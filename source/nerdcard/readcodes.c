/**
 * Provides a function to read strings from a file.
 *
 * @author  T.Sergeant
 * @version Fall 2020
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


/*
 * We are using the painful fgets rather than fscanf b/c for some reason
 * fscanf insists on crashing when integrated with assembly code.
 */
int readCodes(struct Code *a[], char filename[])
{
	FILE * fp;
	int n, id, score;
	char *temp;
	char str[264];
	char *tok;

	n= 0;
	fp= fopen(filename,"r");

  	while (fgets(str, 264, fp) != NULL) {
		temp= str;
		a[n]= (struct Code *) malloc(sizeof(struct Code));
		tok= strsep(&temp," ");
		a[n]->id= atoi(tok);
		tok= strsep(&temp," ");
		a[n]->score= atoi(tok);
		strcpy(a[n]->description, temp);
		(a[n]->description)[strlen(a[n]->description)-1]= '\0'; // toss out \n
		n++;
	}
	fclose(fp);

	return n;
}
