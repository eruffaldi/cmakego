cmake_minimum_required(VERSION 3.0)
find_package(cmakego REQUIRED COMPONENTS opencv OPTIONAL_COMPONENTS flann)

set(CMAKEGO_BOOST program_options) # workaround
find_package(cmakego REQUIRED COMPONENTS boost)