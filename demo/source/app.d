import std.stdio;
import std.format;
import std.string;

import raylib;
import raymath;

void main() {
  writeln("Starting a raylib example.");

  SetTargetFPS(60);
  InitWindow(800, 640, "Hello, World!");
  scope (exit)
    CloseWindow(); // see https://dlang.org/spec/statement.html#scope-guard-statement

  while (!WindowShouldClose()) {
    BeginDrawing();
    ClearBackground(Colors.RAYWHITE);
    DrawText("Hello, World!", 330, 300, 28, Colors.BLACK);
    auto vec1 = Vector2(0, 0);
    auto vec2 = Vector2(100, 100);
    auto sum = Vector2Add(vec1, vec2);
    DrawText(format("Vector2Add: %s + %s = %s", vec1, vec2, sum).toStringz, 20, 20, 20, Colors.BLACK);
    EndDrawing();
  }

  writeln("Ending a raylib example.");
}
