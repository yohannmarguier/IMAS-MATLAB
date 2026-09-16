#include "imas_mex_utils.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    al_status_t status = {0, ""};
    enum imas_mex_operation operationType;
    char * operation;
    char * path;
    char * message;

    if (nrhs != 4)
        mexErrMsgIdAndTxt("IMAS:imas_test_inject_skipped_path:nargin",
                          "Status, operation, path, and message inputs required.");
    if (nlhs != 0)
        mexErrMsgIdAndTxt("IMAS:imas_test_inject_skipped_path:nargout",
                          "No outputs required.");
    if (!mxIsNumeric(prhs[0]) || !mxIsScalar(prhs[0]))
        mexErrMsgIdAndTxt("IMAS:imas_test_inject_skipped_path:notScalar",
                          "Status must be a numeric scalar.");
    if (!mxIsChar(prhs[1]) || !mxIsChar(prhs[2]) || !mxIsChar(prhs[3]))
        mexErrMsgIdAndTxt("IMAS:imas_test_inject_skipped_path:notChar",
                          "Operation, path, and message must be character arrays.");

    operation = mxArrayToString(prhs[1]);
    path = mxArrayToString(prhs[2]);
    message = mxArrayToString(prhs[3]);
    if (strcmp(operation, "read") == 0)
        operationType = IMAS_MEX_READ_OPERATION;
    else if (strcmp(operation, "write") == 0)
        operationType = IMAS_MEX_WRITE_OPERATION;
    else if (strcmp(operation, "delete") == 0)
        operationType = IMAS_MEX_DELETE_OPERATION;
    else
        mexErrMsgIdAndTxt("IMAS:imas_test_inject_skipped_path:invalid_operation",
                          "Operation must be read, write, or delete.");

    resetErrMsgIdAndTxt();
    resetSkippedPaths();
    status.code = (int) mxGetScalar(prhs[0]);
    strncpy(status.message, message, MAX_ERR_MSG_LEN - 1);
    status.message[MAX_ERR_MSG_LEN - 1] = '\0';

    if (tolerateRefusal(status, operationType, path)) {
        mxFree(operation);
        mxFree(path);
        mxFree(message);
        return;
    }

    mxFree(operation);
    mxFree(path);
    mxFree(message);
    if (status.code != 0)
        my_mexErrMsgIdAndTxt(status, "IMAS:imas_test_inject_skipped_path:");
}
