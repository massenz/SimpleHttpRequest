
project(SimpleHttpRequest)
cmake_minimum_required(VERSION 3.4)


# Version number
set(RELEASE_MAJOR 0)
set(RELEASE_MINOR 1)
set(RELEASE_PATCH 1)

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


set(RELEASE_STRING "${RELEASE_MAJOR}.${RELEASE_MINOR}.${RELEASE_PATCH}-${BUILD_ID}")
message(STATUS "Building Release: ${RELEASE_STRING}")

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -fPIC")

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

# TODO: Add install section

# Examples - demo program.

add_executable(example
    ${SRC}/example.cpp
)
target_link_libraries(example ${LIBS})
