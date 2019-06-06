/* Copyright (c) 1999 - 2004 Stephan Ewert. All rights reserved. */

#include "mex.h"
#include "math.h"
#include "../src/adaptloop.c"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double *insig, *outsig, limit, minlvl;
    int siglen, nsigs, fs;

    /* Check for proper number of arguments. */
    if (nrhs != 4)
    {
        mexErrMsgTxt("Four inputs required.");
    }
    else
    {
        if (nlhs > 1)
        {
            mexErrMsgTxt("Too many output arguments");
        }
    }

    /* The input must be a noncomplex double column vector*/
    siglen = mxGetM(prhs[0]);
    nsigs = mxGetN(prhs[0]);
    if (!mxIsDouble(prhs[0]) || mxIsComplex(prhs[0]))
    {
        mexErrMsgTxt("Input vector must be a noncomplex double column vector.");
    }

    if (!mxGetScalar(prhs[1]))
    {
        mexErrMsgTxt("Samplerate must be an integer value.");
    }
    fs = mxGetScalar(prhs[1]);

    if (!mxGetScalar(prhs[2]))
    {
        mexErrMsgTxt("limit must be a scalar value.");
    }
    limit = mxGetScalar(prhs[2]);

    if (!mxGetScalar(prhs[3]))
    {
        mexErrMsgTxt("minlvl must be a scalar value.");
    }
    minlvl = mxGetScalar(prhs[3]);

    /* Create matrix for the return argument. */
    plhs[0] = mxCreateDoubleMatrix(siglen, nsigs, mxREAL);

    /* Assign pointers to each input and output. */
    insig = mxGetPr(prhs[0]);
    outsig = mxGetPr(plhs[0]);

    /* Call the adaptloop C code. */
    adaptloop(insig, fs, siglen, nsigs, limit, minlvl, outsig);
}
