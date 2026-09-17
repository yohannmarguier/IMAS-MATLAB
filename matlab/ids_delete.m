% ids_delete(expIdx, IDSpath[, occurence])
% 
% Delete the IDS from the open database.
% 
% When a multiversion Data Dictionary shim refuses an individual field, the
% delete can complete partially. MATLAB warns for every refused field; inspect
% imas_get_skipped_paths or imas_get_skipped_path_count immediately afterwards.
% There is no rollback: data deleted before a refusal remains deleted.
%
% expIdx   : index to database, returned by imas_open/imas_create.
% IDSpath  : the IDS/occurrence to delete.
% occurence:
