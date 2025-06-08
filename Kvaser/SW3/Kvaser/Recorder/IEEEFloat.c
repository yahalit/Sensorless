#include "mex.h"


void mexFunction(int nlhs, mxArray *plhs[], 
				 int nrhs, const mxArray *prhs[])
{ 
    long unsigned L ; 
    float f ; 
    f = (float) mxGetPr(prhs[0])[0] ;
    L = * (( long unsigned *)  & f ) ; 
    plhs[0] = mxCreateDoubleMatrix (1, 1, mxREAL);
    mxGetPr( plhs[0])[0] = L ;
}                  
