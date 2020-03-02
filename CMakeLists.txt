
project(SimpleHttpRequest)
cmake_minimum_required(VERSION 3.4)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -fPIC")

###
# Version number
#
set(RELEASE_MAJOR 0)
set(RELEASE_MINOR 1)
set(RELEASE_PATCH 1)
set(RELEASE_STRING "${RELEASE_MAJOR}.${RELEASE_MINOR}.${RELEASE_PATCH}-${BUILD_ID}")
message(STATUS "Building Release: ${RELEASE_STRING}")

###
# External libraries, built via Conan.io
# See conanfile.txt
#
include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup()

# Include common cmake utilities:
include(${COMMON_UTILS_DIR}/commons.cmake OPTIONAL RESULT_VARIABLE COMMONS_FILE)
IF (${COMMONS_FILE} STREQUAL NOTFOUND)
    message(WARNING "Not using CMake utilities")
    set(BUILD_ID 0)
ELSE (${COMMONS_FILE} STREQUAL NOTFOUND)
    get_build_id(BUILD_ID)
ENDIF (${COMMONS_FILE} STREQUAL NOTFOUND)


set(SRC ${CMAKE_SOURCE_DIR})
include_directories(
        ${SRC}
)

set(LIBS
        crypto
        http_parser
        pthread
        uv
)

configure_file(${SRC}/SimpleHttpRequest.hpp
        ${PROJECT_BINARY_DIR}/include
        COPYONLY)

###
# Examples - demo program.
#
add_executable(example
    ${SRC}/example.cpp
)
target_link_libraries(example ${LIBS})
