# Find Aruco
#
# This module defines
#  Aruco_FOUND
#  Aruco_INCLUDE_DIRS
#  Aruco_LIBRARIES
#
# Copyright (c) 2012 I-maginer
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License along with
# this program; if not, write to the Free Software Foundation, Inc., 59 Temple
# Place - Suite 330, Boston, MA 02111-1307, USA, or go to
# http://www.gnu.org/copyleft/lesser.txt
#

# On a new cmake run, we do not need to be verbose
IF(Aruco_INCLUDE_DIR AND Aruco_LIBRARY)
        SET(Aruco_FIND_QUIETLY TRUE)
ENDIF()

# If Aruco_ROOT was defined in the environment, use it.
if (NOT Aruco_ROOT)
  if(NOT "$ENV{ARUCO_ROOT}" STREQUAL "")
    set(Aruco_ROOT $ENV{ARUCO_ROOT})
  else()
    set(Aruco_ROOT $ENV{SCOL_DEPENDENCIES_PATH}/aruco/SDK)
  endif()
endif()

message("Aruco root ${Aruco_ROOT}")

# concat all the search paths
IF(Aruco_ROOT)
    SET(Aruco_INCLUDE_SEARCH_DIRS
          ${Aruco_INCLUDE_SEARCH_DIRS}
          ${Aruco_ROOT}/include
          ${Aruco_ROOT}/include/aruco
    )
    SET(Aruco_LIBRARY_SEARCH_DEBUG_DIRS
        ${Aruco_LIBRARY_SEARCH_DIRS}
        ${Aruco_ROOT}/lib
        ${Aruco_ROOT}/lib/Debug
    )
    SET(Aruco_LIBRARY_SEARCH_RELEASE_DIRS
        ${Aruco_LIBRARY_SEARCH_DIRS}
        ${Aruco_ROOT}/lib
        ${Aruco_ROOT}/lib/Release
    )
ENDIF()

# log message
IF (NOT Aruco_FIND_QUIETLY)
    MESSAGE(STATUS "Checking for Aruco library")
ENDIF()

#message("Aruco search ${Aruco_INCLUDE_SEARCH_DIRS}")


# Search for header files
FIND_PATH(Aruco_INCLUDE_DIR aruco.h
    PATHS ${Aruco_INCLUDE_SEARCH_DIRS})

# Search for libraries files (debug mode)
FIND_LIBRARY(Aruco_LIBRARY_DEBUG aruco
  PATHS ${Aruco_LIBRARY_SEARCH_DEBUG_DIRS})

# Search for libraries files (release mode)
FIND_LIBRARY(Aruco_LIBRARY_RELEASE aruco
  PATHS ${Aruco_LIBRARY_SEARCH_RELEASE_DIRS})

#message("Aruco lib ${Aruco_LIBRARY_RELEASE}")
#message("Aruco inc ${Aruco_INCLUDE_DIR}")

# Configure libraries for debug/release
#SET(Aruco_INCLUDE_DIRS ${Aruco_INCLUDE_DIR} CACHE STRING "Directory containing Aruco header files")
SET(Aruco_INCLUDE_DIRS ${Aruco_INCLUDE_DIR})
#SET(Aruco_LIBRARY debug ${Aruco_LIBRARY_DEBUG} release ${Aruco_LIBRARY_RELEASE})
SET(Aruco_LIBRARY ${Aruco_LIBRARY_RELEASE})
SET(Aruco_LIBRARIES ${Aruco_LIBRARY} CACHE STRING "Aruco libraries files")

IF(Aruco_INCLUDE_DIR AND Aruco_LIBRARY)
    SET(Aruco_FOUND TRUE)
ENDIF()

# Hide those variables in GUI
SET(Aruco_INCLUDE_DIR ${Aruco_INCLUDE_DIR} CACHE INTERNAL "")
SET(Aruco_LIBRARY_DEBUG ${Aruco_LIBRARY_DEBUG} CACHE INTERNAL "")
SET(Aruco_LIBRARY_RELEASE ${Aruco_LIBRARY_RELEASE} CACHE INTERNAL "")
SET(Aruco_LIBRARY ${Aruco_LIBRARY} CACHE INTERNAL "")

# log find result
IF(Aruco_FOUND)
    IF(NOT Aruco_FIND_QUIETLY)
        MESSAGE(STATUS "  libraries: ${Aruco_LIBRARIES}")
        MESSAGE(STATUS "  includes: ${Aruco_INCLUDE_DIRS}")
    ENDIF()
ELSE(Aruco_FOUND)
    IF(NOT Aruco_LIBRARIES)
        MESSAGE(SEND_ERROR, "Aruco library or one of it dependencies could not be found.")
    ENDIF()
    IF(NOT Aruco_INCLUDE_DIRS)
        MESSAGE(SEND_ERROR "Aruco include files could not be found.")
    ENDIF()
ENDIF(Aruco_FOUND)
