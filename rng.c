

#include <stdio.h>
#include <stdlib.h>



int rng(int seed)

{
	srand(seed);
	int x, y;
	x = rand() % 40;
	y = rand() % 30;

	int output = y;
	output += x * 256;

	return output;
}
