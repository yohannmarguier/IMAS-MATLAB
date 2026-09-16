# Generated read traversal contract for tolerated refusals.
#
# A regular build has no shim/mismatched-DD fixture to make a public read refuse
# a path. Inspect the generated sources so every read entry point keeps routing
# its leaf and array-of-structures seams through the shared policy.

set(READ_SOURCES
  "${GET_SOURCE}"
  "${GET_SLICE_SOURCE}"
  "${GET_SAMPLE_SOURCE}"
)

foreach(READ_SOURCE IN LISTS READ_SOURCES)
  if(NOT EXISTS "${READ_SOURCE}")
    message(FATAL_ERROR "READ-REFUSAL-POLICY-FAILURE: generated source is missing: ${READ_SOURCE}")
  endif()

  file(READ "${READ_SOURCE}" CONTENTS)

  string(FIND "${CONTENTS}"
    "tolerateRefusal(status, IMAS_MEX_READ_OPERATION, field.fieldPath)"
    LEAF_REFUSAL_SITE)
  if(LEAF_REFUSAL_SITE EQUAL -1)
    message(FATAL_ERROR "READ-REFUSAL-POLICY-FAILURE: leaf read refusal is not routed through the chokepoint in ${READ_SOURCE}")
  endif()

  string(SUBSTRING "${CONTENTS}" ${LEAF_REFUSAL_SITE} -1 LEAF_BLOCK)
  string(FIND "${LEAF_BLOCK}"
    "mxArray_default_value(field.datatype, field.dim, &data)"
    DEFAULT_VALUE)
  if(DEFAULT_VALUE EQUAL -1)
    message(FATAL_ERROR "READ-REFUSAL-POLICY-FAILURE: a tolerated leaf refusal must write its default value in ${READ_SOURCE}")
  endif()

  string(FIND "${CONTENTS}"
    "tolerateRefusalWithConsequence(status, IMAS_MEX_READ_OPERATION, field.fieldPath, \"array of structures was set to empty\")"
    ARRAY_REFUSAL_SITE)
  if(ARRAY_REFUSAL_SITE EQUAL -1)
    message(FATAL_ERROR "READ-REFUSAL-POLICY-FAILURE: array-of-structures refusal is not routed through the chokepoint in ${READ_SOURCE}")
  endif()

  string(SUBSTRING "${CONTENTS}" ${ARRAY_REFUSAL_SITE} -1 ARRAY_BLOCK)
  string(FIND "${ARRAY_BLOCK}" "aosArraySize = 0;" EMPTY_ARRAY)
  if(EMPTY_ARRAY EQUAL -1)
    message(FATAL_ERROR "READ-REFUSAL-POLICY-FAILURE: a tolerated array-of-structures refusal must create an empty array in ${READ_SOURCE}")
  endif()
endforeach()
