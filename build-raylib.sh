#!/usr/bin/env bash

DIR=$(dirname "$0")
cd "$DIR"
if [ ! -f libraylib.a ] || [ "$1" == "-f" ]; then
    echo "[dray] Building Raylib static library..."

    # rm -rf raylib_source
    git clone https://github.com/xdrie/raylib.git raylib_source
    cd raylib_source
    git checkout 3.5.0_patch

    git submodule update --init --recursive
    cd src/
    make -j$(nproc) PLATFORM=PLATFORM_DESKTOP RAYLIB_LIBTYPE=STATIC RAYLIB_MODULE_RAYGUI=TRUE

    pwd
    cp ../libraylib.a ../../libraylib.a
    cd ../..
    # rm -rf raylib_source
else
    # delete libraylib.a to force rebuild
    echo "[dray] Raylib library already built."
fi
