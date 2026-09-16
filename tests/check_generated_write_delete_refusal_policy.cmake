# Generated write and delete traversal contract for tolerated refusals.
#
# A regular build has no shim/mismatched-DD fixture to make a public write or
# delete refuse a path. Inspect the generated sources to ensure each generated
# traversal continues only at the leaf and array-of-structures seams, and that
# root-entry resets preserve one record across ids_put's delete and write phases.

set(WRITE_SOURCES
  "${PUT_SOURCE}"
  "${PUT_SLICE_SOURCE}"
)

foreach(WRITE_SOURCE IN LISTS WRITE_SOURCES)
  if(NOT EXISTS "${WRITE_SOURCE}")
    message(FATAL_ERROR "WRITE-DELETE-REFUSAL-POLICY-FAILURE: generated source is missing: ${WRITE_SOURCE}")
  endif()

  file(READ "${WRITE_SOURCE}" CONTENTS)

  string(FIND "${CONTENTS}"
    "tolerateRefusal(status, IMAS_MEX_WRITE_OPERATION, field.fieldPath)"
    LEAF_REFUSAL_SITE)
  if(LEAF_REFUSAL_SITE EQUAL -1)
    message(FATAL_ERROR "WRITE-DELETE-REFUSAL-POLICY-FAILURE: leaf write refusal is not routed through the chokepoint in ${WRITE_SOURCE}")
  endif()

  string(FIND "${CONTENTS}"
    "tolerateRefusalWithConsequence(status, IMAS_MEX_WRITE_OPERATION, field.fieldPath, \"array of structures subtree was not written\")"
    ARRAY_REFUSAL_SITE)
  if(ARRAY_REFUSAL_SITE EQUAL -1)
    message(FATAL_ERROR "WRITE-DELETE-REFUSAL-POLICY-FAILURE: array-of-structures write refusal is not routed through the chokepoint in ${WRITE_SOURCE}")
  endif()

  string(SUBSTRING "${CONTENTS}" ${ARRAY_REFUSAL_SITE} -1 ARRAY_BLOCK)
  string(FIND "${ARRAY_BLOCK}" "aosArraySize = 0;" EMPTY_ARRAY)
  if(EMPTY_ARRAY EQUAL -1)
    message(FATAL_ERROR "WRITE-DELETE-REFUSAL-POLICY-FAILURE: a tolerated array-of-structures write refusal must skip its subtree in ${WRITE_SOURCE}")
  endif()
endforeach()

if(NOT EXISTS "${DELETE_SOURCE}")
  message(FATAL_ERROR "WRITE-DELETE-REFUSAL-POLICY-FAILURE: generated source is missing: ${DELETE_SOURCE}")
endif()

file(READ "${DELETE_SOURCE}" DELETE_CONTENTS)
string(FIND "${DELETE_CONTENTS}"
  "tolerateRefusal(status, IMAS_MEX_DELETE_OPERATION, fieldPath)"
  DELETE_REFUSAL_SITE)
if(DELETE_REFUSAL_SITE EQUAL -1)
  message(FATAL_ERROR "WRITE-DELETE-REFUSAL-POLICY-FAILURE: leaf delete refusal is not routed through the chokepoint in ${DELETE_SOURCE}")
endif()

foreach(ENTRY_SOURCE IN ITEMS "${PUT_ENTRY_SOURCE}" "${PUT_SLICE_ENTRY_SOURCE}" "${DELETE_ENTRY_SOURCE}")
  if(NOT EXISTS "${ENTRY_SOURCE}")
    message(FATAL_ERROR "WRITE-DELETE-REFUSAL-POLICY-FAILURE: generated source is missing: ${ENTRY_SOURCE}")
  endif()

  file(READ "${ENTRY_SOURCE}" ENTRY_CONTENTS)
  string(REGEX MATCHALL "resetSkippedPaths\\(\\)" RESET_SITES "${ENTRY_CONTENTS}")
  list(LENGTH RESET_SITES RESET_COUNT)
  if(NOT RESET_COUNT EQUAL 1)
    message(FATAL_ERROR "WRITE-DELETE-REFUSAL-POLICY-FAILURE: ${ENTRY_SOURCE} must reset the skipped-path record exactly once on entry")
  endif()
endforeach()

string(FIND "${DELETE_CONTENTS}" "resetSkippedPaths();" DELETE_RESET_SITE)
if(NOT DELETE_RESET_SITE EQUAL -1)
  message(FATAL_ERROR "WRITE-DELETE-REFUSAL-POLICY-FAILURE: ids_put's internal delete traversal must preserve its caller's skipped-path record")
endif()
