import std.stdio;

import raylib;

void main() {
  writeln("Starting a raylib example.");

  // test raymath
  assert(Clamp(2, 0, 1) == 1);

  SetTargetFPS(60);
  InitWindow(800, 640, "Hello, World!");
  scope (exit)
    CloseWindow(); // see https://dlang.org/spec/statement.html#scope-guard-statement

  while (!WindowShouldClose()) {
    BeginDrawing();
    ClearBackground(Colors.RAYWHITE);
    DrawText("Hello, World!", 330, 300, 28, Colors.BLACK);
    EndDrawing();
  }

  writeln("Ending a raylib example.");
}
