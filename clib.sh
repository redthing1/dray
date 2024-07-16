#!/usr/bin/env bash

set -e

# Common variables
PROJECT="dray"
LIB_NAME="raylib"
SOURCETREE_URL="https://github.com/redthing1/raylib"
SOURCETREE_DIR="raylib_source"
SOURCETREE_BRANCH="5.0.0_patch"
LIB_FILE_NAME="libraylib.a"
LIB_FILE_BUILD_NAME="src/$LIB_FILE_NAME"
PACKAGE_DIR=$(dirname "$0")

# Utility variables
LN="ln"
if [[ "$OSTYPE" == "darwin"* ]]; then
    LN="gln"
fi

# Function to check if a command is available
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to ensure a command is available
ensure_command() {
    if ! command_exists "$1"; then
        echo "Error: $1 is not installed or not in PATH"
        echo "Please install $1 and try again"
        exit 1
    fi
    # echo "$1 is available"
}

# Ensure all required commands are available
ensure_command "git"
ensure_command "make"

# Function to prepare the source
prepare() {
    echo "[$PROJECT] preparing $LIB_NAME source..."
    cd "$PACKAGE_DIR"
    
    if [ -d $SOURCETREE_DIR ]; then
        echo "[$PROJECT] using existing source: $SOURCETREE_DIR"
    else
        echo "[$PROJECT] getting source to build $LIB_NAME"
        git clone --depth 1 --branch $SOURCETREE_BRANCH $SOURCETREE_URL $SOURCETREE_DIR
    fi

    cd $SOURCETREE_DIR
    git submodule update --init --recursive
    # echo "[$PROJECT] finished preparing $LIB_NAME source"
}

# Function to build the library
build() {
    echo "[$PROJECT] starting build of $LIB_NAME"
    cd "$PACKAGE_DIR/$SOURCETREE_DIR"
    
    # START BUILD
    if [ "$CLEAN" = "1" ]; then
        echo "[$PROJECT] cleaning $LIB_NAME build"
        make -C src clean
    fi
    make -C src -j$(nproc) $BUILD_ARGS
    # END BUILD

    echo "[$PROJECT] finished build of $LIB_NAME"
    echo "[$PROJECT] linking $LIB_NAME binary ($LIB_FILE_NAME) to $PACKAGE_DIR"
    $LN -vrfs $(pwd)/$LIB_FILE_BUILD_NAME $PACKAGE_DIR/$LIB_FILE_NAME
    # ensure the library is available
    if [ ! -f "$PACKAGE_DIR/$LIB_FILE_NAME" ]; then
        echo "Error: $LIB_NAME library not found at $PACKAGE_DIR/$LIB_FILE_NAME"
        exit 1
    fi
}

# Main execution
main() {
    # export all other KEY=VALUE pairs as environment variables
    for arg in "${@:2}"; do
        export $arg
    done
    if [ "$1" = "prepare" ]; then
        prepare
    elif [ "$1" = "build" ]; then
        build $@
    else
        echo "Usage: $0 [prepare|build] [build arguments...]"
        exit 1
    fi
}

main "$@"