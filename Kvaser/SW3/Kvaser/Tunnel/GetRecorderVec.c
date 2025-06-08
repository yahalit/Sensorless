
#include "mex.h"
#include <string.h>



void mexFunction(int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[]) {

    int unsigned cnt, c1, vlen , TOTAL_DATA_LEN , FieldType;
	double *DecodedVal ; 
    union 
	{
		float f ; 
		long  l ; 
 		long unsigned  ul ; 
        short s; 
        short unsigned us ; 
		char c[4] ; 
	} u ; 
	
    double* pValues; 
    mwSize dims[2] = { 1, 1 };

    if (nlhs != 1)
    {
        mexErrMsgTxt("GetRecorderVec Must return exactly on vector");
    }
    if (nrhs != 2 || !mxIsDouble(prhs[0]) || mxIsComplex(prhs[0]) || !mxIsDouble(prhs[1]) || mxIsComplex(prhs[1]) || ((int)(mxGetN(prhs[1]) * mxGetM(prhs[1])) != 1 ))
    {
        mexErrMsgTxt("call GetRecorderVec(array,data type) ");
    }
    TOTAL_DATA_LEN = (int unsigned)(mxGetN(prhs[0]) * mxGetM(prhs[0])) >> 2 ; 

    if ( (TOTAL_DATA_LEN * 4 ) != mxGetN(prhs[0]) * mxGetM(prhs[0]))
    {
        mexErrMsgTxt("GetRecorderVec argument - incorrect input length");
    }
    FieldType = (int) mxGetPr(prhs[1])[0] ;
    pValues = mxGetPr(prhs[0]); 
	
    plhs[0] = mxCreateDoubleMatrix(1, TOTAL_DATA_LEN, mxREAL);
    DecodedVal = (double*)mxGetPr(plhs[0]);
	for ( cnt = 0 ; cnt < TOTAL_DATA_LEN; cnt++ )
	{ 
		u.c[0] = (char) (*pValues++) ; 
		u.c[1] = (char)(*pValues++);
		u.c[2] = (char)(*pValues++);
		u.c[3] = (char)(*pValues++);
		
		//2 float 4 unsigned 8 short 
		
		switch (FieldType ) // Float 
		{ 
        case 0: // long 
            DecodedVal[cnt] = u.l;
            break; 
        case  2: // Float 
            DecodedVal[cnt] = u.f ;
            break; 
        case  4: 
            DecodedVal[cnt] = u.ul;
            break;
        case  8:
            DecodedVal[cnt] = u.s;
        case  12:
            DecodedVal[cnt] = u.us;
            break;
        }
	} 
	
} 