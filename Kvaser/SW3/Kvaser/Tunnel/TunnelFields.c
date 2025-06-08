
#include "mex.h"
#include <string.h>

#include "MainFieldNames.h"

double DecodedVal[256] ; 


void mexFunction(int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[]) {

    int unsigned cnt, c1, vlen ;
	union 
	{
		float f ; 
		long  l ; 
		char c[4] ; 
	} u ; 
	
    double* pValues; 
    mwSize dims[2] = { 1, 1 };

    if (nlhs != 1)
    {
        mexErrMsgTxt("TunnelFields Must return exactly on struct");
    }
    if (nrhs != 1 || !mxIsDouble(prhs[0]) || mxIsComplex(prhs[0])) 
    {
        mexErrMsgTxt("TunnelFields Must accept one double array");
    }
    if ( (TOTAL_DATA_LEN * 4 ) != mxGetN(prhs[0]) * mxGetM(prhs[0]))
    {
        mexErrMsgTxt("TunnelFields argument - incorrect input length");
    }
    pValues = mxGetPr(prhs[0]); 
	
	for ( cnt = 0 ; cnt < TOTAL_DATA_LEN; cnt++ )
	{ 
		u.c[0] = *pValues++ ; 
		u.c[1] = *pValues++ ; 
		u.c[2] = *pValues++ ; 
		u.c[3] = *pValues++ ; 
		
		if (FieldTypes[cnt] == 1 ) // Float 
		{ 
			DecodedVal[cnt] = u.f ; 
		} 
		else
		{ 
			DecodedVal[cnt] = u.l ; 
		} 
	} 
	
	
    mxArray* pMxSubStruct[NUMBER_OF_FIELDS];

    /* Create a 1-by-n array of structs. */

    plhs[0] = mxCreateStructArray(2, dims, NUMBER_OF_FIELDS, struct_names);
    for (cnt = 0; cnt < NUMBER_OF_FIELDS; cnt++)
    {
        pMxSubStruct[cnt] = mxCreateStructArray(2, dims, str_len[cnt], str_ptr[cnt]);
        for (c1 = 0; c1 < str_len[cnt]; c1++)
        {
            mxSetFieldByNumber(pMxSubStruct[cnt], 0,c1, mxCreateDoubleScalar(DecodedVal[map_ptr[cnt][c1]]));
        }
        mxSetFieldByNumber(plhs[0], 0 , cnt, pMxSubStruct[cnt]);
    }
} 