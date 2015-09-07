# cmakego
Simpler way of declaring libraries used in CMake using the virtual libraries notation. This notation allows to express include and librarie dependencies at once. Provided with packages for applications dealing with OpenGL, Computer Vision and Media

# example
``` cpp
	cmake_minimum_required(VERSION 3.1)
	include(cmakego.cmake)

	add_definitions(--std=c++11 -DGLM_FORCE_RADIANS)
	usepackage(opengl glfw glew glm boost assimp)

	add_definitions(-DBOOST_NOLOG)
	add_executable(go1 go1.cpp)
	target_link_libraries(go1 p::opengl p::glew p::glfw p::glm p::boost p::assimp )

	#add_executable(go2 go1.cpp)
```