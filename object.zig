const std = @import("std");
usingnamespace @import("./color.zig");
usingnamespace @import("./vector2.zig");
usingnamespace @import("./object.zig");
const c = @cImport({
    @cInclude("SDL.h");
});


pub const Object = struct {

  position: Vector2,
  size: Vector2,
  velocity: Vector2,
  damping: f64,
  color: Color,
  centered: bool,
  fill: bool,
  z_index: i32,

  pub fn init(nposition: Vector2, nsize: Vector2, ncolor: Color, nz_index: i32) Object {
    var velocity = Vector2.init(0, 0);
    var damping:f64 = 1.0;
    var centered = false;
    var fill = true;
    return Object{
        .position = nposition,
        .size = nsize,
        .color = ncolor,
        .z_index = nz_index,
        .velocity = velocity,
        .damping = damping,
        .centered = centered,
        .fill = fill,
    };
  }

  pub fn apply_impulse(self: Object, x: f64, y: f64) void {
    .velocity.x += x;
    .velocity.y += y;
  }

  pub fn update_velocity(self: Object, delta: f64) void {
    .position.x += velocity.x * delta;
    .position.y += velocity.y * delta;
    .velocity.x *= damping;
    .velocity.y *= damping;
  }

};
