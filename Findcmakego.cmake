#include cmakego from this location
include(${CMAKE_CURRENT_LIST_DIR}/cmakego.cmake)
message(STATUS ${cmakego_FIND_COMPONENTS})
if(cmakego_FIND_COMPONENTS)
usepackage(${cmakego_FIND_COMPONENTS} REQUIRED)
endif()
if(cmakego_FIND_OPTIONAL_COMPONENTS)
usepackage(${cmakego_FIND_OPTIONAL_COMPONENTS})
endif()

