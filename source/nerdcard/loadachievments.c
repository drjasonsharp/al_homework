/**
 * Provides a function to read strings from a file.
 *
 * @author  T.Sergeant
 * @version Fall 2016
 *
 */

#include<stdio.h>
#include<stdlib.h>
#define MAXSTR 27

struct Achievements {
	int id;
	int score;
	char[256] description;
};


int loadAchievements(Achievements a[], char filename[])
{
	FILE * fp;
	int n;

	n= 0;
	fp= fopen(filename,"r");
  	while (fscanf(fp,"%d %d ",&(a[n].id),&(a[n].score)) > 0) {
  		fgets(a[n].description,256,fp);
		n++;
	}
	fclose(fp);

	return n;
}
