#include "mex.h"


size_t msize(const mxArray *px ) 
{
	return mxGetM(px) * mxGetN(px) ; 
} 
#define fout plhs[0]

char * fieldnames[128] ; 

void mexFunction(int nlhs, mxArray *plhs[], 
				 int nrhs, const mxArray *prhs[])
{ 
// Three arguments: 
// [0] Vector of variables
// [1] Vector of attributes:  2: Float , 4: Unsigned , 8: short 
// [2] Cell array of names 
// 
	long len , cnt ; 
	const mxArray *pVars ; 
	const mxArray *pAtr  ; 
	const mxArray *pNames ; 
	mxArray *px , *pNextName; 
	mwSize dims[2];
	
	union 
	{ 
	float f ; 
	long  l ; 
	short s ;
	long unsigned ul ; 
	short unsigned us ; 
	}u ; 
	unsigned long d ; 

	char *str ; 
	
	if ( nlhs != 1 ) 
	{ 
		mexErrMsgTxt("Expecteing exactly one output var \n");
	} 
	
	if (nrhs != 3 ) 
	{ 
		mexErrMsgTxt("Arguments: Var vector, Atribute vector , names  \n");
	} 
	pVars = prhs[0] ; 
	pAtr  = prhs[1] ; 
	pNames = prhs[2] ; 
	
	len = ( long)msize( pVars ) ; 
	if ( len < 2 || len > 128  || !mxIsDouble(pVars) || len != msize( pAtr ) || !mxIsDouble(pAtr) || len != msize( pNames ) || !mxIsCell(pNames) ) 
	{ 
		mexErrMsgTxt("Arguments: Var vector, 1 to 128 long , Atribute vector , names , all same length \n");
	} 
	
	dims[0] = 1 ; dims[1] = 1 ; 
	
	for ( cnt = 0 ; cnt < len ; cnt++ ) 
	{ 
		pNextName = mxGetCell(pNames, cnt);
		if ( !mxIsChar (pNextName)) 
		{ 
			mexErrMsgTxt("Name array includes a non-string \n");
		} 
		fieldnames[cnt] = mxArrayToString(pNextName);
        //mxSetCell(fout, jstruct, mxDuplicateArray(tmp));
	} 

	
    fout = mxCreateStructArray(2 , dims, len , fieldnames);

	for ( cnt = 0 ; cnt < len ; cnt++ ) 
	{ 
		mxFree(fieldnames[cnt]) ; 
	} 

	for ( cnt = 0 ; cnt < len ; cnt++ ) 
	{
		d = (long unsigned) mxGetPr(pVars)[cnt]; 
		//2: Float , 4: Unsigned , 8: short 
		switch ( (int) mxGetPr(pAtr)[cnt] ) 
		{ 
		case 0: 
			u.l = * ((long*) &d)  ;    
		mxSetFieldByNumber(fout, 0 , cnt, mxCreateDoubleScalar( u.l ) ) ; 
			break ; 
		case 2: 
			u.f = * ((float*) &d)  ;    
			mxSetFieldByNumber(fout, 0 , cnt, mxCreateDoubleScalar( u.f ) ) ; 
			break ; 
		case 4: 
			u.ul = * ((unsigned long*) &d)  ;    
			mxSetFieldByNumber(fout, 0 , cnt, mxCreateDoubleScalar( u.ul ) ) ; 
			break ; 
		case 8 : 
			u.s = * ((short*) &d)  ;    
			mxSetFieldByNumber(fout, 0 , cnt, mxCreateDoubleScalar( u.s ) ) ; 
			break ; 
		case 12: 
			u.us = * ((unsigned short*) &d)  ;    
			mxSetFieldByNumber(fout, 0 , cnt, mxCreateDoubleScalar( u.us ) ) ; 
			break ; 
		default: 
			mexErrMsgTxt("Unknown attribute \n");
		} 
		
	} 

}                  
