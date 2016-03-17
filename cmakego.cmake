# cmakego - Emanuele Ruffaldi, Scuola Superiore Sant'Anna 2015-2016
#
# usepackage([GLOBAL] [REQUIRED] packages...)
# Then use the package as p::packagename
# GLOBAL means that the properties are propagated to include and link of all projects
# REQUIRED means that it is passed to the find_package
#
# TODO special options for find boost
# TODO more libraries
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH};${CMAKE_CURRENT_LIST_DIR}/cmake_modules)
function(usepackage)
	set(globaluse)
	set(isrequired)
	foreach(name ${ARGV})
		if(${name} STREQUAL GLOBAL)
			set(globaluse 1)
		elseif(${name} STREQUAL REQUIRED)
			set(isrequired REQUIRED)
		elseif(${name} STREQUAL NOREQUIRED)
			set(isrequired)
		endif()
	endforeach()
	foreach(name ${ARGV})
		if(${name} STREQUAL GLOBAL)	

		elseif(${name} STREQUAL REQUIRED)
		elseif(${name} STREQUAL NOREQUIRED)
		else()
			if(${name} STREQUAL opengl)	
				find_package(OpenGL ${isrequired})
				if(OPENGL_FOUND)
					add_library(p::opengl INTERFACE IMPORTED)
					set_property(TARGET p::opengl PROPERTY INTERFACE_LINK_LIBRARIES ${OPENGL_LIBRARIES})
					set_property(TARGET p::opengl PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${OPENGL_INCLUDE_DIR}")
				endif()
			elseif(${name} STREQUAL glib2)
				find_package(GLIB2 ${isrequired})
				if(GLIB2_FOUND)
					add_library(p::glib2 INTERFACE IMPORTED)
					set_property(TARGET p::glib2 PROPERTY INTERFACE_LINK_LIBRARIES ${GLIB2_LIBRARIES} gobject-2.0)
					set_property(TARGET p::glib2 PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${GLIB2_INCLUDE_DIRS}")
				endif()
			elseif(${name} STREQUAL gstreamer)
				usepackage(glib2)
				find_package(gstreamer ${isrequired})
				if(GSTREAMER_FOUND)
					add_library(p::gstreamer INTERFACE IMPORTED)
					set_property(TARGET p::gstreamer PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${GSTREAMER_INCLUDE_DIR}")
					set_property(TARGET p::gstreamer PROPERTY INTERFACE_LINK_LIBRARIES ${GSTREAMER_LIBRARIES} p::glib2)
				endif()
			elseif(${name} STREQUAL glew)
				usepackage(opengl)
				find_package(Glew ${isrequired})
				if(GLEW_FOUND)
					add_library(p::glew INTERFACE IMPORTED)
					set_property(TARGET p::glew PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${GLEW_INCLUDE_DIR}")
					set_property(TARGET p::glew PROPERTY INTERFACE_LINK_LIBRARIES ${GLEW_LIBRARIES} p::opengl)
				endif()
			elseif(${name} STREQUAL glfw)
				usepackage(opengl)
				find_package(GLFW3 ${isrequired})
				if(GLFW3_FOUND)
					add_library(p::glfw INTERFACE IMPORTED)
					
					# the following are needed when glfw is loaded in static form under OSX, in practice we need to pull some 
					# OSX system libraries
					if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
						find_library(COCOA_LIBRARY Cocoa)
						find_library(COREVIDEO_LIBRARY CoreVideo)
						find_library(IOKIT_FRAMEWORK IOKit)
						find_library(QTKIT_FRAMEWORK QtKit)
						find_library(COREMEDIA_FRAMEWORK CoreMedia)
						find_library(CORE_FOUNDATION_FRAMEWORK CoreFoundation)
						find_library(AV_FOUNDATION_FRAMEWORK AVFoundation)
						set(OS_GLFW_EXTRA
								${COCOA_LIBRARY}
								${COREVIDEO_LIBRARY}
								${IOKIT_FRAMEWORK}
								${QTKIT_FRAMEWORK}
								${COREMEDIA_FRAMEWORK}
								${AV_FOUNDATION_FRAMEWORK}
								${CORE_FOUNDATION_FRAMEWORK})
					endif()
					set_property(TARGET p::glfw PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${GLFW3_INCLUDE_DIRS}")
					set_property(TARGET p::glfw PROPERTY INTERFACE_LINK_LIBRARIES ${GLFW3_LIBRARIES} ${OS_GLFW_EXTRA} p::opengl)
				endif()
			elseif(${name} STREQUAL eigen)
				find_package(Eigen3 ${isrequired})
				if(EIGEN3_FOUND)
					add_library(p::eigen INTERFACE IMPORTED)
					set_property(TARGET p::eigen PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${EIGEN3_INCLUDE_DIR})
				elseif(${isrequired})
					error("Cannot find REQUIRED EIGEN")
				endif()
			elseif(${name} STREQUAL glm)
				find_package(GLM ${isrequired})
				if(GLM_FOUND)			
					add_library(p::glm INTERFACE IMPORTED)
					set_property(TARGET p::glm PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${GLM_INCLUDE_DIRS})
				endif()
			elseif(${name} STREQUAL boost)
				find_package(Boost ${isrequired})
				if(Boost_FOUND)
					add_library(p::boost INTERFACE IMPORTED)
					set_property(TARGET p::boost PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${Boost_INCLUDE_DIRS})
					set_property(TARGET p::boost PROPERTY INTERFACE_LINK_LIBRARIES ${Boost_LIBRARIES})
				endif()
			elseif(${name} STREQUAL assimp)
				find_package(AssImp ${isrequired})
				if(AssImp_FOUND)
					add_library(p::assimp INTERFACE IMPORTED)
					set_property(TARGET p::assimp PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${ASSIMP_INCLUDE_DIRS})
					set_property(TARGET p::assimp PROPERTY INTERFACE_LINK_LIBRARIES ${ASSIMP_LIBRARIES})
					set_property(TARGET p::assimp PROPERTY INTERFACE_LINK_DIRECTORIES ${ASSIMP_LIBRARY_DIRS})
					# THE FOLLOWING IS NEEDED due to a limit in FindAssImp
					link_directories(${ASSIMP_LIBRARY_DIRS})
				endif()
			elseif(${name} STREQUAL opencv)
				find_package(OpenCV ${isrequired})
				if(OpenCV_FOUND)
					add_library(p::opencv INTERFACE IMPORTED)
					set_property(TARGET p::opencv PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${OpenCV_INCLUDE_DIRS})
					set_property(TARGET p::opencv PROPERTY INTERFACE_LINK_LIBRARIES ${OpenCV_LIBS})
					#set_property(TARGET p::opencv PROPERTY INTERFACE_LINK_DIRECTORIES ${ASSIMP_LIBRARY_DIRS})
					# THE FOLLOWING IS NEEDED due to a limit in FindAssImp
					#link_directories(${ASSIMP_LIBRARY_DIRS})
				endif()								
			elseif(${name} STREQUAL aruco)
				message(XX CHECK ARUCO)
				find_package(Aruco ${isrequired})
				if(Aruco_FOUND)
					add_library(p::aruco INTERFACE IMPORTED)
					set_property(TARGET p::aruco PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${Aruco_INCLUDE_DIR})
					set_property(TARGET p::aruco PROPERTY INTERFACE_LINK_LIBRARIES ${Aruco_LIBRARY} p::opencv)
					#set_property(TARGET p::aruco PROPERTY INTERFACE_LINK_DIRECTORIES ${ASSIMP_LIBRARY_DIRS})
					# THE FOLLOWING IS NEEDED due to a limit in FindAssImp
					#link_directories(${ASSIMP_LIBRARY_DIRS})
				elseif(isrequired)
					message(FATAL_ERROR Missing ARUCO)
				endif()		
			elseif(${name} STREQUAL json)
				find_package(JsonCpp ${isrequired})
				if(JsonCpp_FOUND)
					add_library(p::json INTERFACE IMPORTED)
					set_property(TARGET p::json PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${JSONCPP_INCLUDE_DIR})
					set_property(TARGET p::json PROPERTY INTERFACE_LINK_LIBRARIES ${JSONCPP_LIBRARY})
					#set_property(TARGET p::json PROPERTY INTERFACE_LINK_DIRECTORIES ${ASSIMP_LIBRARY_DIRS})
					# THE FOLLOWING IS NEEDED due to a limit in FindAssImp
					#link_directories(${ASSIMP_LIBRARY_DIRS})
				endif()		
			endif()

			#TODO: add more useful such as: OpenNI2,lz4,zeromq,
			
			if(${globaluse})
				link_libraries(p::${name})
				include_directories(p::${name})
			endif()
		endif()
	endforeach()
endfunction()
