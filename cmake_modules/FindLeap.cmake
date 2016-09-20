# Find Leap
#
# Finds the libraries and header files for the Leap SDK for Leap Motion's
# hand tracker.
#
# This module defines
# LEAP_FOUND       - Leap was found
# LEAP_INCLUDE_DIR - Directory containing LEAP header files
# LEAP_LIBRARY     - Library name of Leap library
# LEAP_INCLUDE_DIRS- Directories required by CMake convention
# LEAP_LIBRARIES   - Libraries required by CMake convention
#
# Based on the FindFMODEX.cmake of Team Pantheon.

# Don't be verbose if previously run successfully
set(LEAP_SDK_ROOT $ENV{LEAP_ROOT})
if(NOT LEAP_SDK_ROOT)
    set(LEAP_SDK_ROOT "/home/pippo/Libraries/coco_deps/LeapSDK-2.3.0/")
    message(STATUS "Variable LEAP_ROOT not set - using default LeapSDK directory: " ${LEAP_SDK_ROOT} )
endif()

IF(LEAP_INCLUDE_DIR AND LEAP_LIBRARY)
    SET(LEAP_FIND_QUIETLY TRUE)
ENDIF(LEAP_INCLUDE_DIR AND LEAP_LIBRARY)

# Set locations to search
IF(UNIX)
    SET(LEAP_INCLUDE_SEARCH_DIRS
        /usr/include
        /usr/local/include
        /opt/leap/include
        /opt/leap_sdk/include
        /opt/include
        ${LEAP_SDK_ROOT}/include
        INTERNAL)

    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
        if(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
            set(LEAP_LIBRARY_SEARCH_DIRS "${LEAP_SDK_ROOT}/lib/x64")
        elseif(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
            set(LEAP_LIBRARY_SEARCH_DIRS "${OVR_SDK_ROOT}/lib")
        endif()
    else()
        if(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
            set(LEAP_LIBRARY_SEARCH_DIRS "${LEAP_SDK_ROOT}/lib/x86")
        elseif(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
            set(LEAP_LIBRARY_SEARCH_DIRS "${OVR_SDK_ROOT}/lib")
        endif()
    endif(CMAKE_SIZEOF_VOID_P EQUAL 8)
    SET(LEAP_LIBRARY_SEARCH_DIRS
        ${LEAP_LIBRARY_SEARCH_DIRS}
        /usr/lib
        /usr/lib64
        /usr/local/lib
        /usr/local/lib64
        /opt/leap/lib
        /opt/leap/lib64
        /opt/leap_sdk/lib
        /opt/leap_sdk/lib64
        INTERNAL)
    #SET(LEAP_INC_DIR_SUFFIXES PATH_SUFFIXES leap)
ELSE(UNIX)
    #WIN32
    SET(LEAP_INC_DIR_SUFFIXES PATH_SUFFIXES inc)
    SET(LEAP_LIB_DIR_SUFFIXES PATH_SUFFIXES lib)
ENDIF(UNIX)

IF(NOT LEAP_FIND_QUIETLY)
    
ENDIF(NOT LEAP_FIND_QUIETLY)

# Search for header files
FIND_PATH(LEAP_INCLUDE_DIR Leap.h
    PATHS ${LEAP_INCLUDE_SEARCH_DIRS}
    PATH_SUFFIXES ${LEAP_INC_DIR_SUFFIXES})

# Search for library
FIND_LIBRARY(LEAP_LIBRARY Leap
    PATHS ${LEAP_LIBRARY_SEARCH_DIRS}
    PATH_SUFFIXES ${LEAP_LIB_DIR_SUFFIXES})

if (LEAP_INCLUDE_DIR AND LEAP_LIBRARY)
    set(LEAP_FOUND TRUE)
    SET(LEAP_INCLUDE_DIRS ${LEAP_INCLUDE_DIR} )
    SET(LEAP_LIBRARIES ${LEAP_LIBRARY} )

    #INCLUDE(FindPackageHandleStandardArgs)
    #FIND_PACKAGE_HANDLE_STANDARD_ARGS(Leap DEFAULT_MSG LEAP_LIBRARY LEAP_INCLUDE_DIR)

    #MARK_AS_ADVANCED(LEAP_INCLUDE_DIR LEAP_LIBRARY)
endif()
