
%% Test Class Definition
classdef imas_utils_unit_tests < matlab.unittest.TestCase

  properties (ClassSetupParameter)
  end

  %% Class-level setup
  methods (TestClassSetup)
    function verifySkippedPathsAreInitiallyEmpty(TestCase)
      skippedPaths = imas_get_skipped_paths;

      TestCase.verifySize(skippedPaths, [0 0]);
      TestCase.verifyEqual(fieldnames(skippedPaths), ...
        {'operation'; 'path'; 'message'; 'code'});
      TestCase.verifyEqual(imas_get_skipped_path_count, 0);
    end
  end

  %% Test Method Parameters
  properties (TestParameter)
    IDSname = IDS_list.';
    ntime = struct('small',3);
  end

  %% Test Method Block
  methods (Test)

    function testZeroStatusDoesNotRecordASkippedPath(TestCase)
      imas_test_inject_skipped_path(0, 'read', '', '');

      skippedPaths = imas_get_skipped_paths;

      TestCase.verifySize(skippedPaths, [0 0]);
      TestCase.verifyEqual(imas_get_skipped_path_count, 0);
    end

    function testRefusalPolicyTruthTable(TestCase)
      operations = {'read', 'write', 'delete'};
      statuses = [0, -1, -2, -3, -4, -1000, -1050, -1099, -999, -1100];

      for operationIndex = 1:numel(operations)
        operation = operations{operationIndex};
        for status = statuses
          call = @() imas_test_inject_skipped_path(status, operation, 'a/b', 'shim refusal');
          isRefusal = status >= -1099 && status <= -1000;

          if (isRefusal)
            TestCase.verifyWarning(call, ['IMAS:' operation ':refused']);
          elseif (status < 0)
            TestCase.verifyError(call, 'IMAS:imas_test_inject_skipped_path:internal_error');
          else
            call();
          end

          skippedPaths = imas_get_skipped_paths;
          TestCase.verifyEqual(imas_get_skipped_path_count, numel(skippedPaths));
          TestCase.verifyEqual(numel(skippedPaths), double(isRefusal));
        end
      end
    end

    function testSkippedPathRecordRoundTripsAndResets(TestCase)
      imas_test_inject_skipped_path(-1050, 'write', 'equilibrium/time_slice', 'cannot convert this field');
      skippedPaths = imas_get_skipped_paths;

      TestCase.verifyEqual(imas_get_skipped_path_count, 1);
      TestCase.verifyEqual(skippedPaths.operation, 'write');
      TestCase.verifyEqual(skippedPaths.path, 'equilibrium/time_slice');
      TestCase.verifyEqual(skippedPaths.message, 'cannot convert this field');
      TestCase.verifyEqual(skippedPaths.code, -1050);

      imas_test_inject_skipped_path(-1000, 'delete', 'equilibrium', 'cannot delete this field');
      skippedPaths = imas_get_skipped_paths;

      TestCase.verifyEqual(imas_get_skipped_path_count, 1);
      TestCase.verifyEqual(skippedPaths.operation, 'delete');
      TestCase.verifyEqual(skippedPaths.path, 'equilibrium');
    end

    function rand(TestCase, IDSname, ntime)
      ids1 = ids_rand(IDSname, ntime, 0);
      ids2 = ids_rand(IDSname, ntime, 2);
    end

    function gen(TestCase, IDSname)
      ids = ids_gen(IDSname);
    end

    function int_to_double(TestCase, IDSname, ntime)
      ids = ids_rand(IDSname, ntime, 0);
      sdi = ids_int_to_double(IDSname, ids);
    end
    
    function double_to_int(TestCase, IDSname, ntime)
      ids = ids_int_to_double(IDSname, ids_rand(IDSname, ntime, 0));
      sdi = ids_double_to_int(IDSname, ids);
    end
    
    function empty_to_nan(TestCase, IDSname, ntime)
      ids = ids_rand(IDSname, ntime, 0);
      sdi = ids_empty_to_nan(IDSname, ids);
    end
    
    function nan_to_empty(TestCase, IDSname, ntime)
      ids = ids_rand(IDSname, ntime, 0);
      sdi = ids_nan_to_empty(IDSname, ids);
    end
    
    function cell_to_struct(TestCase, IDSname, ntime)
      params = imas_get_mex_params;
      imas_set_mex_params('use_cell_array_for_array_of_structures',true);
      ids = ids_rand(IDSname, ntime, 0);
      sdi = ids_cell_to_struct(IDSname, ids);
      imas_set_mex_params(params);
    end
    
    function struct_to_cell(TestCase, IDSname, ntime)
      params = imas_get_mex_params;
      imas_set_mex_params('use_cell_array_for_array_of_structures',false);
      ids = ids_rand(IDSname, ntime, 0);
      sdi = ids_struct_to_cell(IDSname, ids);
      imas_set_mex_params(params);
    end
    
  end

end
