const std = @import("std");
usingnamespace @import("./color.zig");
usingnamespace @import("./vector2.zig");
const c = @cImport({
    @cInclude("SDL.h");
});

pub const Object = struct {
    position: Vector2,
    size: Vector2,
    velocity: Vector2,
    damping: f64,
    color: Color,
    fill: bool,
    z_index: i32,

    pub fn init(nposition: Vector2, nsize: Vector2, ncolor: Color, nz_index: i32) Object {
        var velocity = Vector2.init(0, 0);
        var damping: f64 = 1.0;
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

    pub fn apply_impulse(self: *Object, x: f64, y: f64) void {
        self.velocity.x += x;
        self.velocity.y += y;
    }

    pub fn update_velocity(self: *Object, delta: f64) void {
        self.position.x += self.velocity.x * delta;
        self.position.y += self.velocity.y * delta;
        self.velocity.x *= self.damping;
        self.velocity.y *= self.damping;
    }
};
