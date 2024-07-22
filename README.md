[![DUB Package](https://img.shields.io/dub/v/dray.svg)](https://code.dlang.org/packages/dray)

# dray

dlang bindings to [redthing1 raylib](https://github.com/redthing1/raylib) **v5.0.0** (based on the official upstream [5.0.0 release](https://github.com/raysan5/raylib/releases/tag/5.0.0)).

patches:
+ `raygui` included
+ HIDPI enabled
+ `physac` included

## usage

all you need to do is add this package as a dependency and it should automatically build the Raylib C library and link it in.
if for some reason you want to use a custom build, just place your own `libraylib.a` in the package root (usually something like `~/.dub/packages/dray_xxx`.

note that `raylib` has some of its own dependencies such as OpenGL.

## build (unix/linux/mac)
simply run a build as usual. a script will clone and build raylib from source.
```sh
dub build
```

## build (windows)
place the static libraries for GLFW and a static libraries from a prebuilt raylib (with raygui) in your dray package dir.
prebuilt libraries are available here:
+ [raylib+raygui](https://github.com/redthing1/dray/releases/tag/v5.0.0-r1)
+ [glfw 3.4](https://github.com/glfw/glfw/releases/3.4/)

then, run a build as usual, which will compile the bindings.
```
dub build
```

refer to [this github actions workflow](https://github.com/bmchtech/rengfx/blob/3413eca319d450b6c04eeb2b5855c08a6d54dd17/.github/workflows/windows.yml) for more details.

## demo

see [demo](demo/), which demonstrates a simple application using these Raylib bindings.
