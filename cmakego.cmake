# cmakego - Emanuele Ruffaldi, Scuola Superiore Sant'Anna 2015-2016
#
# usepackage([GLOBAL] [REQUIRED] packages...)
# Then use the package as p::packagename
# GLOBAL means that the properties are propagated to include and link of all projects
# REQUIRED means that it is passed to the find_package
#
# TODO special options for find boost
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
			set(xname p::${name})
			if(TARGET ${xname})
			else()
				if(${name} STREQUAL opengl)	
					find_package(OpenGL ${isrequired})
					if(OPENGL_FOUND)
						add_library(p::opengl INTERFACE IMPORTED)
						set_property(TARGET p::opengl PROPERTY INTERFACE_LINK_LIBRARIES ${OPENGL_LIBRARIES})
						set_property(TARGET p::opengl PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${OPENGL_INCLUDE_DIR}")
					endif()		
				elseif(${name} STREQUAL egl)	
					find_package(EGL ${isrequired})
					if(EGL_FOUND)
						add_library(p::egl INTERFACE IMPORTED)
						set_property(TARGET p::egl PROPERTY INTERFACE_LINK_LIBRARIES ${EGL_LIBRARIES})
						set_property(TARGET p::egl PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${EGL_INCLUDE_DIR}")
					endif()		
				elseif(${name} STREQUAL opengles2)	
					find_package(OpenGLES2 ${isrequired})
					if(OPENGLES2_FOUND)
						add_library(p::opengles2 INTERFACE IMPORTED)
						set_property(TARGET p::opengles2 PROPERTY INTERFACE_LINK_LIBRARIES ${OPENGLES2_LIBRARIES})
						set_property(TARGET p::opengles2 PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${OPENGLES2_INCLUDE_DIR}")
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
					find_package(GStreamer ${isrequired} COMPONENTS gstreamer-app gstreamer-pbutils)
					if(GSTREAMER_FOUND)
						add_library(p::gstreamer INTERFACE IMPORTED)
						set_property(TARGET p::gstreamer PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${GSTREAMER_INCLUDE_DIRS}")
						set_property(TARGET p::gstreamer PROPERTY INTERFACE_LINK_LIBRARIES ${GSTREAMER_LIBRARIES} ${GSTREAMER_APP_LIBRARIES} p::glib2)
					endif()		
				elseif(${name} STREQUAL glew)
					usepackage(opengl)
					find_package(Glew ${isrequired})
					if(GLEW_FOUND)
						add_library(p::glew INTERFACE IMPORTED)
						set_property(TARGET p::glew PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${GLEW_INCLUDE_DIR}")
						set_property(TARGET p::glew PROPERTY INTERFACE_LINK_LIBRARIES ${GLEW_LIBRARIES} p::opengl)
					endif()		
				elseif(${name} STREQUAL freetype)
					find_package(freetype ${isrequired})
					if(FREETYPE_FOUND)
						add_library(p::freetype INTERFACE IMPORTED)
						set_property(TARGET p::freetype PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${FREETYPE_INCLUDE_DIRS}")
						set_property(TARGET p::freetype PROPERTY INTERFACE_LINK_LIBRARIES ${FREETYPE_LIBRARIES})
					endif()		
				elseif(${name} STREQUAL display)
					if(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
						set(DISPLAY_INCLUDE_DIR)
						find_library(X11_LIBRARY X11)
						find_library(XX_LIBRARY Xxf86vm)
						find_library(XRANDR_LIBRARY Xrandr)
						find_library(XI_LIBRARY Xi)
						find_library(XEXT_LIBRARY Xext)
						find_library(XINEARAMA_LIBRARY Xinerama)
						find_library(XCURSOR_LIBRARY Xcursor)
						set(DISPLAY_LIBRARIES 
									${X11_LIBRARY}
									${XX_LIBRARY}
									${XRANDR_LIBRARY}
									${XI_LIBRARY}
									${XEXT_LIBRARY}
									${XINEARAMA_LIBRARY}
									${XCURSOR_LIBRARY}
									-lrt -lm -lusb-1.0 
									)						
					elseif(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
						set(DISPLAY_INCLUDE_DIR /System/Library/Frameworks)
						find_library(COCOA_LIBRARY Cocoa)
						find_library(COREVIDEO_LIBRARY CoreVideo)
						find_library(IOKIT_FRAMEWORK IOKit)
						find_library(QTKIT_FRAMEWORK QtKit)
						find_library(COREMEDIA_FRAMEWORK CoreMedia)
						find_library(CORE_FOUNDATION_FRAMEWORK CoreFoundation)
						find_library(AV_FOUNDATION_FRAMEWORK AVFoundation)
						set(DISPLAY_LIBRARIES
								${COCOA_LIBRARY}
								${COREVIDEO_LIBRARY}
								${IOKIT_FRAMEWORK}
								${QTKIT_FRAMEWORK}
								${COREMEDIA_FRAMEWORK}
								${AV_FOUNDATION_FRAMEWORK}
								${CORE_FOUNDATION_FRAMEWORK})
					endif(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
					add_library(p::display INTERFACE IMPORTED)
					set_property(TARGET p::display PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${DISPLAY_INCLUDE_DIR}")
					set_property(TARGET p::display PROPERTY INTERFACE_LINK_LIBRARIES ${DISPLAY_LIBRARIES})					
				elseif(${name} STREQUAL glfw)
					usepackage(opengl display)
					find_package(GLFW3 ${isrequired})
					if(GLFW3_FOUND)
						add_library(p::glfw INTERFACE IMPORTED)
						set_property(TARGET p::glfw PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${GLFW3_INCLUDE_DIRS}")
						set_property(TARGET p::glfw PROPERTY INTERFACE_LINK_LIBRARIES ${GLFW3_LIBRARIES} p::opengl p::display)
					endif()		
				elseif(${name} STREQUAL kdl)
					# NOTE for Drop-in Replacement Trac_IK: https://bitbucket.org/traclabs/trac_ik/src/HEAD/trac_ik_lib/
					find_package(KDL ${isrequired})
					if(KDL_FOUND)
					#KDL_DEFINES KDL_LINK_DIRS
						add_library(p::kdl INTERFACE IMPORTED)
						set_property(TARGET p::kdl PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${KDL_INCLUDE_DIRS}")
						set_property(TARGET p::kdl PROPERTY INTERFACE_LINK_LIBRARIES ${KDL_LIBS})
					endif()		
				elseif(${name} STREQUAL ovr)
					find_package(OVR ${isrequired})
					if(OVR_FOUND)
						add_library(p::ovr INTERFACE IMPORTED)
						set_property(TARGET p::ovr PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${OVR_INCLUDES})
						set_property(TARGET p::ovr PROPERTY INTERFACE_LINK_LIBRARIES ${OVR_LIBRARIES})
					endif()
				elseif(${name} STREQUAL eigen)
					find_package(Eigen3 ${isrequired})
					if(EIGEN3_FOUND)
						add_library(p::eigen INTERFACE IMPORTED)
						set_property(TARGET p::eigen PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${EIGEN3_INCLUDE_DIR})
					endif()		
				elseif(${name} STREQUAL glm)
					find_package(GLM ${isrequired})
					if(GLM_FOUND)			
						add_library(p::glm INTERFACE IMPORTED)
						set_property(TARGET p::glm PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${GLM_INCLUDE_DIRS})
					endif()		
				elseif(${name} STREQUAL boost)
					find_package(Boost COMPONENTS program_options ${isrequired})
					if(Boost_FOUND)
						add_library(p::boost INTERFACE IMPORTED)
						set_property(TARGET p::boost PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${Boost_INCLUDE_DIRS})
						set_property(TARGET p::boost PROPERTY INTERFACE_LINK_LIBRARIES ${Boost_LIBRARIES})

						add_library(p::boost::program_options INTERFACE IMPORTED)
						set_property(TARGET p::boost::program_options PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${Boost_INCLUDE_DIRS})
						set_property(TARGET p::boost::program_options PROPERTY INTERFACE_LINK_LIBRARIES ${Boost_PROGRAM_OPTIONS_LIBRARY})
					endif()		
				elseif(${name} STREQUAL assimp)
					find_package(AssImp ${isrequired})
					if(ASSIMP_FOUND)
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
					usepackage(opencv)
					find_package(Aruco ${isrequired})
					if(Aruco_FOUND)
						add_library(p::aruco INTERFACE IMPORTED)
						set_property(TARGET p::aruco PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${Aruco_INCLUDE_DIR})
						set_property(TARGET p::aruco PROPERTY INTERFACE_LINK_LIBRARIES ${Aruco_LIBRARY} p::opencv)
						#set_property(TARGET p::aruco PROPERTY INTERFACE_LINK_DIRECTORIES ${ASSIMP_LIBRARY_DIRS})
						# THE FOLLOWING IS NEEDED due to a limit in FindAssImp
						#link_directories(${ASSIMP_LIBRARY_DIRS})
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
				elseif(${name} STREQUAL ffmpeg)
					find_package(FFmpeg ${isrequired})
					if (FFMPEG_FOUND)
						add_library(p::ffmpeg::avformat INTERFACE IMPORTED)
						set_property(TARGET p::ffmpeg::avformat PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${FFMPEG_LIBAVFORMAT_INCLUDE_DIRS})
						set_property(TARGET p::ffmpeg::avformat PROPERTY INTERFACE_LINK_LIBRARIES ${FFMPEG_AVFORMAT_LIBRARIES})

						add_library(p::ffmpeg::avfilter INTERFACE IMPORTED)
						set_property(TARGET p::ffmpeg::avfilter PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${FFMPEG_LIBAVFILTER_INCLUDE_DIRS})
						set_property(TARGET p::ffmpeg::avfilter PROPERTY INTERFACE_LINK_LIBRARIES ${FFMPEG_LIBAVFILTER_LIBRARIES})

						add_library(p::ffmpeg::avdevice INTERFACE IMPORTED)
						set_property(TARGET p::ffmpeg::avdevice PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${FFMPEG_LIBAVDEVICE_INCLUDE_DIRS})
						set_property(TARGET p::ffmpeg::avdevice PROPERTY INTERFACE_LINK_LIBRARIES ${FFMPEG_LIBAVDEVICE_LIBRARIES})

						add_library(p::ffmpeg::avcodec INTERFACE IMPORTED)
						set_property(TARGET p::ffmpeg::avcodec PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${FFMPEG_LIBAVCODEC_INCLUDE_DIRS})
						set_property(TARGET p::ffmpeg::avcodec PROPERTY INTERFACE_LINK_LIBRARIES ${FFMPEG_LIBAVCODEC_LIBRARIES})

						add_library(p::ffmpeg::avutil INTERFACE IMPORTED)
						set_property(TARGET p::ffmpeg::avutil PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${FFMPEG_LIBAVUTIL_INCLUDE_DIRS})
						set_property(TARGET p::ffmpeg::avutil PROPERTY INTERFACE_LINK_LIBRARIES ${FFMPEG_LIBAVUTIL_LIBRARIES})

						add_library(p::ffmpeg::swscale INTERFACE IMPORTED)
						set_property(TARGET p::ffmpeg::swscale PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${FFMPEG_LIBSWSCALE_INCLUDE_DIRS})
						set_property(TARGET p::ffmpeg::swscale PROPERTY INTERFACE_LINK_LIBRARIES ${FFMPEG_LIBSWSCALE_LIBRARIES})

						add_library(p::ffmpeg INTERFACE IMPORTED)
						set_property(TARGET p::ffmpeg PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${FFMPEG_INCLUDE_DIRS})
						set_property(TARGET p::ffmpeg PROPERTY INTERFACE_LINK_LIBRARIES ${FFMPEG_LIBRARIES})
					endif()
				elseif(${name} STREQUAL x264)
					find_package(x264 ${isrequired})
					if (X264_FOUND)
						add_library(p::x264 INTERFACE IMPORTED)
						set_property(TARGET p::x264 PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${X264_INCLUDE_DIR})
						set_property(TARGET p::x264 PROPERTY INTERFACE_LINK_LIBRARIES ${X264_LIBRARY})
					endif()
				elseif(${name} STREQUAL zeromq)
					find_package(ZeroMQ ${isrequired})
					if (ZeroMQ_FOUND)
						add_library(p::zeromq INTERFACE IMPORTED)
						set_property(TARGET p::zeromq PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${ZeroMQ_INCLUDE_DIR})
						set_property(TARGET p::zeromq PROPERTY INTERFACE_LINK_LIBRARIES ${ZeroMQ_LIBRARY})
					endif()
				elseif(${name} STREQUAL nlopt)
					find_package(Nlopt ${isrequired})
					if (NLOPT_FOUND)
						add_library(p::nlopt INTERFACE IMPORTED)
						set_property(TARGET p::nlopt PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${NLOPT_INCLUDE_DIR})
						set_property(TARGET p::nlopt PROPERTY INTERFACE_LINK_LIBRARIES ${NLOPT_LIBRARIES})
					endif()
				elseif(${name} STREQUAL libusb)
					find_package(libusb-1.0 ${isrequired})
					if (LIBUSB_1_FOUND)
						add_library(p::libusb INTERFACE IMPORTED)
						set_property(TARGET p::libusb PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${LIBUSB_1_INCLUDE_DIRS})
						set_property(TARGET p::libusb PROPERTY INTERFACE_LINK_LIBRARIES ${LIBUSB_1_LIBRARIES})
					endif()
				elseif(${name} STREQUAL portaudio)
					find_package(portaudio ${isrequired})
					if (PORTAUDIO_FOUND)
						add_library(p::portaudio INTERFACE IMPORTED)
						set_property(TARGET p::portaudio PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${PORTAUDIO_INCLUDE_DIRS})
						set_property(TARGET p::portaudio PROPERTY INTERFACE_LINK_LIBRARIES ${PORTAUDIO_LIBRARIES})
					endif()				
				elseif(${name} STREQUAL freenect)
					find_package(freenect ${isrequired})
					if (FREENECT_FOUND)
						add_library(p::freenect INTERFACE IMPORTED)
						set_property(TARGET p::freenect PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${FREENECT_INCLUDE_DIR})
						set_property(TARGET p::freenect PROPERTY INTERFACE_LINK_LIBRARIES ${FREENECT_LIBRARIES})
					endif()				
				elseif(${name} STREQUAL freenect2)
					find_package(freenect2 ${isrequired})
					if (FREENECT2_FOUND)
						add_library(p::freenect2 INTERFACE IMPORTED)
						set_property(TARGET p::freenect2 PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${FREENECT2_INCLUDE_DIRS})
						set_property(TARGET p::freenect2 PROPERTY INTERFACE_LINK_LIBRARIES ${FREENECT2_LIBRARY})
					endif()				
				elseif(${name} STREQUAL openni2)
					find_package(openni2 ${isrequired})
					if (OPENNI2_FOUND)
						add_library(p::openni2 INTERFACE IMPORTED)
						set_property(TARGET p::openni2 PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${OPENNI2_INCLUDE_DIRS})
						set_property(TARGET p::openni2 PROPERTY INTERFACE_LINK_LIBRARIES ${OPENNI2_LIBRARIES})
					endif()				
				elseif(${name} STREQUAL leap)
					find_package(leap ${isrequired})
					if (LEAP_FOUND)
						add_library(p::leap INTERFACE IMPORTED)
						set_property(TARGET p::leap PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${LEAP_INCLUDE_DIR})
						set_property(TARGET p::leap PROPERTY INTERFACE_LINK_LIBRARIES ${LEAP_LIBRARIES})
					endif()				
				elseif(${name} STREQUAL cairo)
					find_package(cairo ${isrequired})
					if (CAIRO_FOUND)
						add_library(p::cairo INTERFACE IMPORTED)
						set_property(TARGET p::cairo PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${CAIRO_INCLUDE_DIRS})
						set_property(TARGET p::cairo PROPERTY INTERFACE_LINK_LIBRARIES ${CAIRO_LIBRARIES})
					endif()				
				elseif(${name} STREQUAL lz4)
					find_package(lz4 ${isrequired})
					if (LZ4_FOUND)
						add_library(p::lz4 INTERFACE IMPORTED)
						set_property(TARGET p::lz4 PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${LZ4_INCLUDE_DIR})
						set_property(TARGET p::lz4 PROPERTY INTERFACE_LINK_LIBRARIES ${LZ4_LIBRARY})
					endif()								
				elseif(${name} STREQUAL tinyxml)
					find_package(TinyXML ${isrequired})
					if (TINYXML_FOUND)
						add_library(p::tinyxml INTERFACE IMPORTED)
						set_property(TARGET p::tinyxml PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${TINYXML_INCLUDE_DIRS})
						set_property(TARGET p::tinyxml PROPERTY INTERFACE_LINK_LIBRARIES ${TINYXML_LIBRARY_DIRS})
					endif()				
				elseif(${name} STREQUAL tinyxml2)
					find_package(TinyXML2 ${isrequired})
					if (TINYXML2_FOUND)
						add_library(p::tinyxml2 INTERFACE IMPORTED)
						set_property(TARGET p::tinyxml2 PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${TINYXML2_INCLUDE_DIR})
						set_property(TARGET p::tinyxml2 PROPERTY INTERFACE_LINK_LIBRARIES ${TINYXML2_LIBRARY})
					endif()				
				elseif(${name} STREQUAL flann)
					find_package(FLANN ${isrequired})
					if (FLANN_FOUND)
						add_library(p::flann INTERFACE IMPORTED)
						set_property(TARGET p::flann PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${FLANN_INCLUDE_DIRS})
						set_property(TARGET p::flann PROPERTY INTERFACE_LINK_LIBRARIES ${FLANN_LIBRARIES})
					endif()				
				else()
					include(cmakego_{$name} OPTIONAL RESULT_VARIABLE missing)
					if(NOT ${missing})
						message(FATAL_ERROR Unknown Target ${xname} prvide cmake_{$name})
					endif()
					if(NOT TARGET ${xname} AND isrequired)
						message(FATAL_ERROR Included file cmake_{$name} has not provided {$xname})
					endif()
				endif()
				if(NOT TARGET ${xname} AND isrequired)
					message(FATAL_ERROR "Required Package ${name} NOT FOUND")
				endif()

				#TODO: add more useful such as: OpenNI2,lz4,zeromq,
				if(${globaluse})
					link_libraries(p::${name})
					include_directories(p::${name})
				endif()
			endif()
		endif()
	endforeach()
endfunction()
