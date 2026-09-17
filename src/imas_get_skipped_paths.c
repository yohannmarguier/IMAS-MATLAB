#include "imas_mex_utils.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    mxArray * paths;

    if (nrhs != 0)
        mexErrMsgIdAndTxt("IMAS:imas_get_skipped_paths:nargin",
                          "No inputs required.");
    if (nlhs > 1)
        mexErrMsgIdAndTxt("IMAS:imas_get_skipped_paths:nargout",
                          "One output maximum required.");

    paths = getSkippedPaths();
    if (nlhs == 1)
        plhs[0] = paths;
    else
        mxDestroyArray(paths);
}
