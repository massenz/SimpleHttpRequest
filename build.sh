#!/bin/bash

set -ex

# Prints the absolute path of the file given as $1
#
function abspath {
    echo $(python -c "import os; print(os.path.abspath(\"$1\"))")
}

BASEDIR="$(abspath $(dirname $0))"
BUILD_DIR="${BASEDIR}/build"

mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

conan install ${BASEDIR} -if=${BUILD_DIR} -pr=default --build=missing

if [[ -d ${COMMON_UTILS_DIR} ]]; then
  UTILS="-DCOMMON_UTILS_DIR=${COMMON_UTILS_DIR}"
fi

cmake -DCMAKE_CXX_COMPILER=$(which clang++) ${UTILS} ..
cmake --build . --target all -- -j 6
