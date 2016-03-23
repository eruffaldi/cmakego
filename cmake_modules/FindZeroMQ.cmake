# - Try to find libzmq
# Once done, this will define
#
#  ZeroMQ_FOUND - system has libzmq
#  ZeroMQ_INCLUDE_DIRS - the libzmq include directories
#  ZeroMQ_LIBRARIES - link these to use libzmq


IF (UNIX)
	# Include dir
	find_path(ZeroMQ_INCLUDE_DIR
	  NAMES zmq.h
	  PATHS /usr/local/include
	  		/usr/include
	  		/opt/local/include
	)

	# Finally the library itself
	find_library(ZeroMQ_LIBRARY
	  NAMES zmq
	  PATHS /usr/local/lib
	  		/usr/lib
	  		/usr/lib/x86_64-linux-gnu
	  		/opt/local/lib
	)
	#message("a ${ZEROMQ_ROOT} ${ZeroMQ_LIBRARY}")
ELSEIF (WIN32)
	find_path(ZeroMQ_INCLUDE_DIR
	  NAMES zmq.h
	  PATHS ${ZEROMQ_ROOT}/include ${CMAKE_INCLUDE_PATH}
	)
	# Finally the library itself
	find_library(ZeroMQ_LIBRARY
	  NAMES zmq
	  PATHS ${ZEROMQ_ROOT}/lib ${CMAKE_LIB_PATH}
	)
ENDIF()

IF (ZeroMQ_INCLUDE_DIR AND ZeroMQ_LIBRARY)
	set(ZeroMQ_FOUND TRUE)
ENDIF()

# Set the include dir variables and the libraries and let libfind_process do the rest.
# NOTE: Singular variables for this library, plural for libraries this this lib depends on.
IF (ZeroMQ_FOUND)
	set(ZeroMQ_PROCESS_INCLUDES ZeroMQ_INCLUDE_DIR ZeroMQ_INCLUDE_DIRS)
	set(ZeroMQ_PROCESS_LIBS ZeroMQ_LIBRARY ZeroMQ_LIBRARIES)

	#message("ZEROMQ ${ZEROMQ_ROOT} ${ZeroMQ_LIBRARY} ${ZeroMQ_INCLUDE_DIR}")
	set(ZMQ_LIBRARY ${ZeroMQ_LIBRARY})
ENDIF()