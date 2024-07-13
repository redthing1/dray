set -xe

# ensure DSTEP environment variable is set
if [ -z "$DSTEP" ]; then
    echo "DSTEP environment variable is not set. please set it to the path of the dstep executable"
    exit 1
fi

$DSTEP ./raylib_source/src/raylib.h -o ./dout/raylib.d
$DSTEP ./raylib_source/src/raymath.h -o ./dout/raymath.d
$DSTEP ./raylib_source/src/rlgl.h -o ./dout/rlgl.d
$DSTEP ./raylib_source/src/raygui.h -o ./dout/raygui.d
