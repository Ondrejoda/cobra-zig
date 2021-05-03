const std = @import("std");
const print = @import("std").debug.print;
usingnamespace @import("./cobra.zig");
usingnamespace @import("./color.zig");
usingnamespace @import("./vector2.zig");
usingnamespace @import("./object.zig");
const c = @cImport({
    @cInclude("SDL.h");
});

const WIDTH:i32 = 1280;
const HEIGHT:i32 = 720;


pub fn main() anyerror!void {
    var bgcolor : Color = Color.init(0, 0, 0, 255);
    var wsize : Vector2 = Vector2.init(WIDTH, HEIGHT);

    var engine : Cobra = try Cobra.init(bgcolor, wsize);

    var paddle : Object = Object.init(Vector2.init(25, (HEIGHT + 300) / 2), Vector2.init(50, 300), Color.init(255, 255, 255, 255), 0);
    paddle.damping = 0.9997;
    try engine.add_object(&paddle);

    var paddle2 : Object = Object.init(Vector2.init(WIDTH - 75, (HEIGHT + 300) / 2), Vector2.init(50, 300), Color.init(255, 255, 255, 255), 0);
    paddle2.damping = 0.9997;
    try engine.add_object(&paddle2);

    var ball : Object = Object.init(Vector2.init(WIDTH / 2, HEIGHT / 2), Vector2.init(30, 30), Color.init(255, 255, 255, 255), 0);
    ball.apply_impulse(500, 500);
    ball.damping = 1.00001;
    try engine.add_object(&ball);

    while (true) {
        engine.start_frame();
        engine.render();
        engine.handle_physics();
        engine.handle_keyboard();
        if (ball.position.y <= 0 or ball.position.y + ball.size.y >= HEIGHT) {
            ball.velocity.y = -ball.velocity.y;
        }
        if (engine.get_object_collision(&ball, &paddle) or engine.get_object_collision(&ball, &paddle2)) {
          ball.velocity.x = -ball.velocity.x;
        }
        if (ball.position.x < -32 or ball.position.x > WIDTH + 2) {
          ball.position = Vector2.init(WIDTH / 2, HEIGHT / 2);
        }
        if (engine.is_key_pressed(c.SDL_SCANCODE_W)) {
          paddle.apply_impulse(0, -2.5);
        }
        if (engine.is_key_pressed(c.SDL_SCANCODE_S)) {
          paddle.apply_impulse(0, 2.5);
        }
        if (engine.is_key_pressed(c.SDL_SCANCODE_UP)) {
          paddle2.apply_impulse(0, -2.5);
        }
        if (engine.is_key_pressed(c.SDL_SCANCODE_DOWN)) {
          paddle2.apply_impulse(0, 2.5);
        }
        if (paddle.position.y != clampf(paddle.position.y, 0, @intToFloat(f64, HEIGHT) - paddle.size.y)) {
          paddle.position.y = clampf(paddle.position.y, 0, @intToFloat(f64, HEIGHT) - paddle.size.y);
          paddle.velocity.y = 0;
        }
        if (paddle2.position.y != clampf(paddle2.position.y, 0, @intToFloat(f64, HEIGHT) - paddle2.size.y)) {
          paddle2.position.y = clampf(paddle2.position.y, 0, @intToFloat(f64, HEIGHT) - paddle2.size.y);
          paddle2.velocity.y = 0;
        }
        ball.position.y = clampf(ball.position.y, 0.0, @intToFloat(f64, HEIGHT) - 30.0);
        engine.end_frame();
    }
}
