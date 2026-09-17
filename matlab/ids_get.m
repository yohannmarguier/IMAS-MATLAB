% out = ids_get(expIdx, IDSpath[, occurence])
% 
% Read the contents of the an IDS into memory.
%
% This method fetches the IDS in its entirety, with all time slices it may
% contain. See ids_get_slice for reading a specific time slice.
%
% Empty fields within the IDS in the Data Entry are returned with the
% default values indicated in :ref:`Default values`.
% A read can be partial when the multiversion shim refuses an individual
% field: the returned IDS retains its normal shape and uses that field's
% default value. Inspect imas_get_skipped_paths or
% imas_get_skipped_path_count after the call for the refused paths.
% 
% Args:
%   expIdx:     Data entry context created with
%               imas_open_uri, imas_open_env, imas_open_env_backend,
%               imas_create_env or imas_create_env_backend.
%   IDSpath:    Name of the IDS to retrieve, e.g. 'core_profiles'.
%   occurence:  Which occurrence of the IDS to read. Defaults to 0.
%
% Returns:
%   The loaded IDS.
