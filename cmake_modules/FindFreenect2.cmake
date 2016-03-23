# - Try to find Freenect2
# Once done this will define
#
#  FREENECT2_FOUND - system has Freenect2
#  FREENECT2_INCLUDE_DIRS - the Freenect2 include directory
#  FREENECT2_LIBRARY - Link these to use Freenect2
#  FREENECT2_LIBRARIES

find_path(FREENECT2_INCLUDE_DIRS NAMES libfreenect2.hpp
	HINTS
	/usr/local/include/libfreenect2/
	/usr/include/libfreenect2
	/usr/local/include/
	/usr/include/
	}
)
 
find_library(FREENECT2_LIBRARY NAMES freenect2 )

if(FREENECT2_INCLUDE_DIRS AND FREENECT2_LIBRARY)
  set(FREENECT2_FOUND TRUE)
endif()

if(FREENECT2_LIBRARY)
    set(FREENECT2_LIBRARY ${FREENECT2_LIBRARY})
endif()

if (FREENECT2_FOUND)
  MESSAGE("-- Found Freenect2 ${FREENECT_LIBRARIES}")
  mark_as_advanced(FREENECT2_INCLUDE_DIRS FREENECT2_LIBRARY FREENECT2_LIBRARIES)
endif()
