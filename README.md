[![DUB Package](https://img.shields.io/dub/v/dray.svg)](https://code.dlang.org/packages/dray)

# dray

dlang bindings to [redthing1 raylib](https://github.com/redthing1/raylib) **v4.2.0** (based on the official upstream [4.2.0 release](https://github.com/raysan5/raylib/releases/tag/4.2.0)).

patches:
+ `raygui` included
+ HIDPI enabled
+ `physac` included
+ coming soon: OpenVR

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
Use the `lib` directory of the archive as `WINLIB_BASE` and the `lib/mingw` directory as `WINLIB_MINGW`.

Then place `raylib.lib` and `WinMM.lib` in the `dray` package directory.
You can get raylib artifacts for dray windows [here](https://github.com/redthing1/raylib/actions/workflows/windows.yml).
You can get `WinMM.lib`, `MSVCRT.lib`, `OLDNAMES.lib` [here](https://github.com/redthing1/dray/releases/download/v4.2.0-r3/winlibs_extra.7z). You should place those in your `WINLIB_BASE` path.

```sh
WINLIB_BASE="/path/to/ldc2-1.28.1-windows-x64/ldc2-1.28.1-windows-x64/lib/" WINLIB_MINGW="/path/to/Downloads/ldc2-1.28.1-windows-x64/ldc2-1.28.1-windows-x64/lib/mingw" dub build --compiler ldc2 --arch=x86_64-windows-msvc
```

finally, remember to copy `phobos2-ldc-shared.dll` and `druntime-ldc-shared.dll` to your executable directory.

## demo

see [demo](demo/), which demonstrates a simple application using these Raylib bindings.
