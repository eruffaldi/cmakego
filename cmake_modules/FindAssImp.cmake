# Find ASSIMP
#
# This module defines
#  ASSIMP_FOUND
#  ASSIMP_INCLUDE_DIRS
#  ASSIMP_LIBRARIES


# On a new cmake run, we do not need to be verbose
IF(ASSIMP_INCLUDE_DIR AND ASSIMP_LIBRARY)
        SET(ASSIMP_FIND_QUIETLY TRUE)
ENDIF()


SET(ASSIMP_INCLUDE_SEARCH_DIRS
      /usr/include/assimp
      /usr/local/include/assimp/
      /opt/local/include/assimp/
)
SET(ASSIMP_LIBRARY_SEARCH_DIRS
      /usr/lib
      /usr/local/lib
      /opt/local/lib
)    

# log message
IF (NOT ASSIMP_FIND_QUIETLY)
    #MESSAGE(STATUS "Checking for ASSIMP library")
ENDIF()


# Search for header files
FIND_PATH(ASSIMP_INCLUDE_DIR Importer.hpp
    PATHS ${ASSIMP_INCLUDE_SEARCH_DIRS})

FIND_LIBRARY(ASSIMP_LIBRARY assimp
  PATHS ${ASSIMP_LIBRARY_SEARCH_DIRS})


SET(ASSIMP_INCLUDE_DIRS ${ASSIMP_INCLUDE_DIR})
SET(ASSIMP_LIBRARIES ${ASSIMP_LIBRARY})

IF(ASSIMP_INCLUDE_DIR AND ASSIMP_LIBRARY)
    SET(ASSIMP_FOUND TRUE)
ENDIF()