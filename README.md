# cmakego
Simpler way of declaring libraries used in CMake using the virtual libraries notation. This notation allows to express include and librarie dependencies at once. Provided with packages for applications dealing with OpenGL, Computer Vision and Media

# example
The following example uses OpeNGL, GLEW, GLFW, GLM and AssImp. Note that dependences have been created between glew/glfw and opengl so the latter is automatically pulled and added.
``` cpp
	cmake_minimum_required(VERSION 3.0)
	include(cmakego.cmake)

	add_definitions(--std=c++11 -DGLM_FORCE_RADIANS)
	usepackage(glfw glew glm boost assimp)

	add_executable(go1 go1.cpp)
	target_link_libraries(go1 p::glew p::glfw p::glm p::boost p::assimp)
```

# Libraries

## real libraries ##

The supported libraries come from the domain of 3D OpenGL/AR being related to the things we typically

* aruco: opencv
* assimp
* boost
* eigen
* ffmpeg
* glib2
* glm
* glew: opengl
* glfw: opengl, display
* gstreamer: glib2
* json
* libusb (1.0)
* opencv
* opengl
* x264
* zeromq

## virtual libraries ##

* display: this is a library for accessing the native system (X11 under Linux, CoCoa under OSX)

#