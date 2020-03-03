
project(SimpleHttpRequest)
cmake_minimum_required(VERSION 3.4)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -fPIC")

# Include common cmake utilities:
include(${COMMON_UTILS_DIR}/commons.cmake OPTIONAL RESULT_VARIABLE COMMONS_FILE)
if(COMMONS_FILE STREQUAL NOTFOUND)
    message(WARNING "Not using CMake utilities")
    set(BUILD_ID 0)
else()
    get_build_id(BUILD_ID)
endif()

##
# Installation directory
#
# The INSTALL_DIR env variable must be set, unless -DINSTALL_DIR is used.
#
if(NOT DEFINED INSTALL_DIR)
    if(DEFINED ENV{INSTALL_DIR})
        set(INSTALL_DIR $ENV{INSTALL_DIR})
    endif()
endif()


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
)

if (DEFINED INSTALL_DIR)
    message(STATUS "Configuring installation of shared libraries "
                   "to ${INSTALL_DIR}/lib and include files "
                   "to ${INSTALL_DIR}/include")

    # Install Libraries and Headers.
    install(DIRECTORY ${CMAKE_BINARY_DIR}/include/ DESTINATION
            ${INSTALL_DIR}/include
            FILES_MATCHING PATTERN "*.h" PATTERN "*.hpp")
    install(DIRECTORY ${CMAKE_BINARY_DIR}/lib/ DESTINATION
            ${INSTALL_DIR}/lib
            FILES_MATCHING PATTERN "*.so*" PATTERN "*.dylib*")
else ()
    message(WARNING "INSTALL_DIR is not defined, make install will not work."
                    " Use -DINSTALL_DIR=/path/to/install to enable")
endif ()

###
# Examples - demo program.
#
add_executable(example
    ${SRC}/example.cpp
)
target_link_libraries(example ${LIBS})

# The same example, with SSL enabled.
#
add_executable(example_with_ssl
    ${SRC}/example.cpp
)
target_link_libraries(example_with_ssl
    ${LIBS}
    ssl
)
target_compile_definitions(example_with_ssl PUBLIC ENABLE_SSL)
