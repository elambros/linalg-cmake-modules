# FindAOCL.cmake
#
# Finds AMD AOCL libraries and headers
#
# The module will define the following variables:
#   AOCL_FOUND          - Found AOCL installation
#   AOCL_INCLUDE_DIR    - Location of AOCL headers (like mkl.h or similar)
#   AOCL_LIBRARIES      - AOCL libraries (BLIS, libFLAME, etc.)
#   AOCL_BLIS_LIBRARY   - BLIS library path
#   AOCL_FLAME_LIBRARY  - libFLAME library path
#
# Environment variable AOCL_ROOT can be used to specify the AOCL installation prefix.

include(CMakeFindDependencyMacro)

if(NOT AOCL_PREFIX)
  set(AOCL_PREFIX $ENV{AOCL_ROOT})
endif()

# AOCL typical components
set(AOCL_COMPONENTS BLIS FLAME)

# AOCL includes
find_path(AOCL_INCLUDE_DIR
  NAMES blis.h
  HINTS ${AOCL_PREFIX}
  PATH_SUFFIXES include
  DOC "AOCL include directory"
)

# Libraries
find_library(AOCL_BLIS_LIBRARY
  NAMES blis
  HINTS ${AOCL_PREFIX}
  PATH_SUFFIXES lib lib64 lib/x86_64
  DOC "AOCL BLIS (BLAS) library"
)

find_library(AOCL_FLAME_LIBRARY
  NAMES flame
  HINTS ${AOCL_PREFIX}
  PATH_SUFFIXES lib lib64 lib/x86_64
  DOC "AOCL libFLAME (LAPACK) library"
)

# Optional: ScaLAPACK (if available)
find_library(AOCL_SCALAPACK_LIBRARY
  NAMES scalapack
  HINTS ${AOCL_PREFIX}
  PATH_SUFFIXES lib lib64 lib/x86_64
  DOC "AOCL ScaLAPACK library"
)

# Optional: libamd and libcamd (used in SuiteSparse etc.)
find_library(AOCL_AMD_LIBRARY
  NAMES amd
  HINTS ${AOCL_PREFIX}
  PATH_SUFFIXES lib lib64 lib/x86_64
  DOC "libamd library (AOCL)"
)

find_library(AOCL_CAMD_LIBRARY
  NAMES camd
  HINTS ${AOCL_PREFIX}
  PATH_SUFFIXES lib lib64 lib/x86_64
  DOC "libcamd library (AOCL)"
)

# Collect libraries
set(AOCL_LIBRARIES ${AOCL_BLIS_LIBRARY} ${AOCL_FLAME_LIBRARY})

if(AOCL_SCALAPACK_LIBRARY)
  list(APPEND AOCL_LIBRARIES ${AOCL_SCALAPACK_LIBRARY})
endif()

if(AOCL_AMD_LIBRARY)
  list(APPEND AOCL_LIBRARIES ${AOCL_AMD_LIBRARY})
endif()

if(AOCL_CAMD_LIBRARY)
  list(APPEND AOCL_LIBRARIES ${AOCL_CAMD_LIBRARY})
endif()

# Version detection (placeholder — AOCL headers rarely contain a direct version macro)
# You can expand this if the AOCL release you're targeting has a known version header

# Final status
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(AOCL
  REQUIRED_VARS AOCL_LIBRARIES AOCL_INCLUDE_DIR
  HANDLE_COMPONENTS
)

mark_as_advanced(
  AOCL_INCLUDE_DIR
  AOCL_LIBRARIES
  AOCL_BLIS_LIBRARY
  AOCL_FLAME_LIBRARY
  AOCL_SCALAPACK_LIBRARY
  AOCL_AMD_LIBRARY
  AOCL_CAMD_LIBRARY
)
