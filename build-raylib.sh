#!/usr/bin/env bash

###
### DEPENDENCY LIBRARY BUILDER SCRIPT
### redthing1
###

set -e

# package config
HOST="dray"
LIB_NAME="raylib"
SOURCETREE_URL="https://github.com/redthing1/raylib"
SOURCETREE_DIR="raylib_source"
SOURCETREE_BRANCH="5.0.0_patch"
LIB_FILE_1="libraylib.a"

BUILD_ARGS=$@

PACKAGE_DIR=$(dirname "$0")
cd "$PACKAGE_DIR"
pushd .

# utility vars
LN="ln"

if [[ "$OSTYPE" == "darwin"* ]]; then
    LN="gln"
fi

echo "[$HOST] building $LIB_NAME library..."

# delete $SOURCETREE_DIR to force re-fetch source
if [ -d $SOURCETREE_DIR ]; then
    echo "[$HOST] source folder already exists, using it."
else
    echo "[$HOST] getting source to build $LIB_NAME"
    # git clone $SOURCETREE_URL $SOURCETREE_DIR
    git clone --depth 1 --branch $SOURCETREE_BRANCH $SOURCETREE_URL $SOURCETREE_DIR
fi

cd $SOURCETREE_DIR
git submodule update --init --recursive

echo "[$HOST] starting build of $LIB_NAME"
#
# START BUILD
#
# build the library
cd src
make clean
make -j$(nproc) $BUILD_ARGS
#
# END BUILD
#

echo "[$HOST] finished build of $LIB_NAME"

echo "[$HOST] copying $LIB_NAME binary ($LIB_FILE_1) to $PACKAGE_DIR"
$LN -vrfs $(pwd)/$LIB_FILE_1 $PACKAGE_DIR/$LIB_FILE_1
popd
