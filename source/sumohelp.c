#include<stdio.h>

typedef struct sumoStruct SUMO;
struct sumoStruct {
  int  rank;        // 1 is best rank ... up to n
  int  height;      // in cm 
  int  weight;      // in kg
  char name[20];    // Last name is first
};

void displaySumoByIndex(SUMO *sumo[], int n)
{
  int i;
  printf(" Rank Height Weight Name\n");
  printf("------------------------\n");

  for (i=0; i<n; i++)
    printf("%4d%6d%8d   %s\n",sumo[i]->rank,sumo[i]->height,
                              sumo[i]->weight,sumo[i]->name);
}


void sortSumoByWeight(SUMO *sumo[], int n)
{
	SUMO * temp;
	int i,j,smallpos;
	for (i=0; i<n-1; i++) {
		smallpos= i;
		for (j=i+1; j<n; j++) {
			if (sumo[j]->weight < sumo[smallpos]->weight)
				smallpos= j;
		}
		temp= sumo[i];
		sumo[i]= sumo[smallpos];
		sumo[smallpos]= temp;
	}
}