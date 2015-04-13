#include <iostream>
#include<vector>
#include <mex.h>
using namespace std;

// Guangyu Zhong : guangyuzhonghikari@gmail.com
vector< vector<int> > gene_adj_mat(double *W, int sp_num, int m, int n)
{

	vector< vector<int> >  affMat(m, vector<int>(n));
	for(int i = 0; i<m*n; ++i)
	{
		affMat[i/n][i%n] = W[i] - 1;
	}
	vector< vector<int> >  spAdjMat(sp_num, vector<int>(sp_num));
	for (int i = 0; i < m - 1; ++i)
	{ 
		for (int j = 0; j < n - 1; ++j)
		{
			if (affMat[i][j] != affMat[i][j+1])
			{
				spAdjMat[affMat[i][j]][affMat[i][j+1]] = 1;
				spAdjMat[affMat[i][j+1]][affMat[i][j]] = 1;
			}
			if (affMat[i][j] != affMat[i+1][j])
			{
				spAdjMat[affMat[i][j]][affMat[i+1][j]] = 1;
				spAdjMat[affMat[i+1][j]][affMat[i][j]] = 1;
			}
			if (affMat[i][j] != affMat[i+1][j+1])
			{
				spAdjMat[affMat[i][j]][affMat[i+1][j+1]] = 1;
				spAdjMat[affMat[i+1][j+1]][affMat[i][j]] = 1;
			}
			if (affMat[i+1][j] != affMat[i][j+1])
			{
				spAdjMat[affMat[i+1][j]][affMat[i][j+1]] = 1;
				spAdjMat[affMat[i][j+1]][affMat[i+1][j]] = 1;
			}
		}
	}
	return spAdjMat;
}




void mexFunction(int numOut, mxArray *pmxOut[],
	int numIn, const mxArray *pmxIn[])
{
	
	double *sp_num = mxGetPr(pmxIn[0]);
	double *m = mxGetPr(pmxIn[1]);
	double *n = mxGetPr(pmxIn[2]);
	double *W = mxGetPr(pmxIn[3]);
	
	//vector< vector<int> > spAdjMat((int)sp_num[0], vector<int>((int)sp_num[0]));
	//spAdjMat = gene_adj_mat(W,  sp_num[0],  m[0],  n[0]);
	vector< vector<int> >  spAdjMat((int)sp_num[0], vector<int>((int)sp_num[0]));
	spAdjMat = gene_adj_mat(W,  sp_num[0],  m[0],  n[0]);
	pmxOut[0] = mxCreateDoubleMatrix(1,(int)(sp_num[0]*sp_num[0]),mxREAL);
	double *adjmat;
	adjmat = mxGetPr(pmxOut[0]);
	for(int i = 0; i<sp_num[0]-1;++i)
		for (int j = 0; j<sp_num[0]-1;++j)
		{
		    adjmat[(int)(i*sp_num[0] + j)] = spAdjMat[i][j];
		}


}