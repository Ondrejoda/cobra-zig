const std = @import("std");
usingnamespace @import("./color.zig");
usingnamespace @import("./vector2.zig");
const c = @cImport({
    @cInclude("SDL.h");
});


pub const Text = struct {

  position: Vector2,
  color: Color,
  text: char,
  fill: bool,
  z_index: i32,

  pub fn init(nposition: Vector2, nsize: Vector2, ncolor: Color, nz_index: i32) Object {
    var velocity = Vector2.init(0, 0);
    var damping:f64 = 1.0;
    var fill = true;
    return Object{
        .position = nposition,
        .size = nsize,
        .color = ncolor,
        .z_index = nz_index,
        .velocity = velocity,
        .damping = damping,
        .fill = fill,
    };
  }

};
