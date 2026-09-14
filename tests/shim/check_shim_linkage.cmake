# Check the actual shared-library dependencies, since a MEX link line that also
# contains Core can resolve the mirrored C ABI symbols without conversion.
execute_process(
  COMMAND "${INSPECT_TOOL}" ${INSPECT_ARGS} "${LIBRARY}"
  RESULT_VARIABLE inspect_result
  OUTPUT_VARIABLE dependencies
  ERROR_VARIABLE inspect_error )
if( NOT inspect_result EQUAL 0 )
  message( FATAL_ERROR "Could not inspect ${LIBRARY}: ${inspect_error}" )
endif()
if( NOT dependencies MATCHES "libimas_mvdd_loader" )
  message( FATAL_ERROR "${LIBRARY} does not depend on the multiversion shim:\n${dependencies}" )
endif()
if( dependencies MATCHES "libal[.]" )
  message( FATAL_ERROR "${LIBRARY} links IMAS-Core directly, bypassing the shim:\n${dependencies}" )
endif()
