#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#define WORD_LENGTH 500

using namespace std;

typedef float real;

//mainly from word2vec_joint.cpp: LoadEmb(), TrainModel()
int main(int argc, char* argv[])
{
	string in_file(argv[1]);
    int which = atoi(argv[2]);//1: syn0 / 2: syn1neg
	string out_file(argv[3]);

	long long words, size, a, b;
    char ch;
    FILE *f_in = fopen(in_file.c_str(), "rb");
    FILE *f_out = fopen(out_file.c_str(), "wb");

	//read model info. & copy to output file
    fscanf(f_in, "%lld", &words);
    fscanf(f_in, "%lld", &size);
    fprintf(f_out, "%lld %lld\n", words, size);

	//allocate memory
	real* tmp_vec = NULL;
    a = posix_memalign((void **)&tmp_vec, 128, (long long)size * sizeof(real) * 2);

	char tmpword[WORD_LENGTH];
    for (b = 0; b < words; b++)
	{
        fscanf(f_in, "%s%c", tmpword, &ch);
        for (a = 0; a < size+size; a++) fread(&tmp_vec[a], sizeof(real), 1, f_in);

		//write to output file
		//cout << tmpword << endl;
        fprintf(f_out, "%s ", tmpword);
		if(which == 1)
            for (a = 0; a < size; a++) fwrite(&tmp_vec[a], sizeof(real), 1, f_out);
		else if(which == 2)
            for (a = 0; a < size; a++) fwrite(&tmp_vec[size + a], sizeof(real), 1, f_out);
		fprintf(f_out, "\n");
    }
    fclose(f_in);
    fclose(f_out);

	return 0;
}

