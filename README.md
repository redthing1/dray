[![DUB Package](https://img.shields.io/dub/v/dray.svg)](https://code.dlang.org/packages/dray)

# dray

dlang bindings to [raylib](https://github.com/redthing1/raylib) **v4.0.0** (based on the official upstream [4.0.0 release](https://github.com/raysan5/raylib/releases/tag/4.0.0)).

patches:
+ `raygui` included
+ HIDPI enabled

## usage

all you need to do is add this package as a dependency and it should automatically build the Raylib C library and link it in.
if for some reason you want to use a custom build, just place your own `libraylib.a` in the package root (usually something like `~/.dub/packages/dray_xxx`.

note that `raylib` has some of its own dependencies such as OpenGL.

## build (unix/linux/mac)
```sh
dub build
```

## build (windows (not recommended))

first, download an LDC2 `win-x64` release to get the native libraries we need.

Then place `raylib.lib` and `WinMM.lib` in the `dray` package directory.

```sh
WINLIB_BASE="/path/to/ldc2-1.28.1-windows-x64/ldc2-1.28.1-windows-x64/lib/" WINLIB_MINGW="/path/to/Downloads/ldc2-1.28.1-windows-x64/ldc2-1.28.1-windows-x64/lib/mingw" dub build --compiler ldc2 --arch=x86_64-windows-msvc
```

finally, remember to copy `phobos2-ldc-shared.dll` and `druntime-ldc-shared.dll` to your executable directory.

## demo

see [demo](demo/), which demonstrates a simple application using these Raylib bindings.
