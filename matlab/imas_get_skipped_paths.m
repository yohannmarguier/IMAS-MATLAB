% skipped_paths = imas_get_skipped_paths
% Return paths the multiversion shim refused during the last root operation.
%
% skipped_paths is an N-by-1 struct array with fields operation, path, message,
% and code. It is a 0-by-0 struct carrying the same field names when no path
% was skipped.
