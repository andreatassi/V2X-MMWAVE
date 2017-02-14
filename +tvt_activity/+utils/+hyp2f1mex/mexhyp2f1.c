/*  mexhyp2f1.c 
 *  Evaluate the Gauss hypergeometric function 2F1(a,b;c;x) of real 
 *  value x, x < 1 
 *  
 *  h = mexhyp2f1(a,b,c,x)
 *  x must be a n x 1 double vector
 *  a,b,c, can be scalars or n x 1 double vectors
 *  h is a n x 1 double vector
 *
 *  Siyi Deng; 10-10-2013; 
 */

#include "mex.h"
#include "mconf.h"

void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	double *a, *b, *c, *x, *h;
	mwSize ma, mb, mc, mx;
    unsigned int i;
	
	if ((nrhs != 4) || (nlhs != 1))
		mexErrMsgIdAndTxt("mexhyp2f1:NumInOutError","Wrong number of input or output.");
	
	if (!mxIsDouble(prhs[0]) || !mxIsDouble(prhs[1]) || !mxIsDouble(prhs[2]) || !mxIsDouble(prhs[3]))
		mexErrMsgIdAndTxt("mexhyp2f1:BadInput","Input must be double arrays.");
		
	ma = mxGetM(prhs[0]);
	mb = mxGetM(prhs[1]);
	mc = mxGetM(prhs[2]);
	mx = mxGetM(prhs[3]);	
	
	if (((ma == 1) && (mb != 1 || mc != 1 )) || ((ma != 1) && (ma != mb || ma != mc || ma != mx)))
		mexErrMsgIdAndTxt("mexhyp2f1:BadInput","Input size mismatch.");
	
	
	plhs[0] = mxCreateDoubleMatrix(mx,1,mxREAL);
	h = mxGetPr(plhs[0]);
	
	a = mxGetPr(prhs[0]);
	b = mxGetPr(prhs[1]);
	c = mxGetPr(prhs[2]);
	x = mxGetPr(prhs[3]);
	
	if (ma == 1) {
		for (i = 0; i < mx; i++) {
			h[i] = hyp2f1(a[0],b[0],c[0],x[i]);
		}
	}
	else {
		for (i = 0; i < mx; i++) {
			h[i] = hyp2f1(a[i],b[i],c[i],x[i]);
		}
	}
		
	return;
		
}

