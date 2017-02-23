# cmakego
Simpler way of declaring libraries used in CMake using the virtual libraries notation. This notation allows to express include and librarie dependencies at once. Provided with packages for applications dealing with OpenGL, Computer Vision and Media

## usage ##

Make the cmakego.cmake accessible to the cmake using CMAKE_MODULE_PATH and then first include it, then use the command usepackage:

cmake -DCMAKE_MODULE_PATH=~/Dropbox/repos/cmakego .

First method is based on find_package much like catkin

``` cpp
find_package(cmagego REQUIRED COMPONENTS ... [REQUIRED])
```

The second requires inclusion of the script and then the usepackage macro:

``` cpp
usepackage(packagename1 ... [GLOBAL] [REQUIRED])
```

The library name is the name of the packagename1 such as eigen, opengl or others. When found it will create the special target p::packagename.

Then the p::packagename can be used in the target_link_libraries of a target to satisfy at once both includes and libraries.

``` cpp
	add_executable(go1 go1.cpp)
	target_link_libraries(go1 p::glew p::glfw p::glm p::boost p::assimp)
```

When REQUIRED is present then the package is enforced otherwise the cmake will terminate.

When GLOBAL is used then the virtual target is added to the global list via link_libraries and include_directories. In this way it is available to all the other targets. 

In addition ALL the dependencies included by cmakego are included in the variable CMAKEGO_PACKAGES

## example ##
The following example uses OpeNGL, GLEW, GLFW, GLM and AssImp. Note that dependences have been created between glew/glfw and opengl so the latter is automatically pulled and added.
``` cpp
	cmake_minimum_required(VERSION 3.0)

	add_definitions(--std=c++11 -DGLM_FORCE_RADIANS)
	find_package(cmakego COMPONENTS glfw glew glm boost assimp)

	add_executable(go1 go1.cpp)
	target_link_libraries(go1 p::glew p::glfw p::glm p::boost p::assimp)
```


# Libraries

## real libraries ##

The supported libraries come from the domain of 3D OpenGL/AR/vision being related to the things we typically work with:

* aruco: opencv
* asio
* assimp
* boost
* cairo
* curl
* display (virtual)
* egl
* eigen
* ffmpeg (and submodules)
* flann
* freenect
* freenect2
* freetype
* glew: opengl
* glfw: opengl, display
* glib2
* glm
* gstreamer: glib2
* json
* kdl
* lame
* leap
* libusb (1.0)
* lz4
* nlopt
* ogre
* ois (for ogre)
* opencv2
* opencv3
* opengl
* opengles2
* openni2
* ovr (Oculus)
* portaudio
* qt4
* qt5
* rbdl
* sdl2
* tinyxml
* tinyxml2
* x264
+ yaml
* zeromq
* zlib
## virtual libraries ##

* display: this is a library for accessing the native system (X11 under Linux, CoCoa under OSX)

# TODO #

* Provide another repository with simple examples for testing the libraries in a simple way. We are interested in coverin all the libraries above.

* Start decomposing the cmakego in functional pieces, now all the libraries are selected in the main script
