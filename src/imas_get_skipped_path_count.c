#include "imas_mex_utils.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    if (nrhs != 0)
        mexErrMsgIdAndTxt("IMAS:imas_get_skipped_path_count:nargin",
                          "No inputs required.");
    if (nlhs > 1)
        mexErrMsgIdAndTxt("IMAS:imas_get_skipped_path_count:nargout",
                          "One output maximum required.");

    if (nlhs == 1)
        plhs[0] = mxCreateDoubleScalar((double) getSkippedPathCount());
}
