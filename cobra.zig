const std = @import("std");
usingnamespace @import("./color.zig");
usingnamespace @import("./vector2.zig");
usingnamespace @import("./object.zig");
usingnamespace @import("./text.zig");
const c = @cImport({
    @cInclude("SDL.h");
});

pub fn clamp(num: i32, min: i32, max: i32) i32 {
    if (num < min) {
        num = min;
    }
    if (num > max) {
        num = max;
    }
    return num;
}

pub fn clampf(num: f64, min: f64, max: f64) f64 {
    if (num < min) {
        return min;
    }
    if (num > max) {
        return max;
    }
    return num;
}

pub const Cobra = struct {
    window: *c.SDL_Window,
    bgcolor: Color,
    renderer: *c.SDL_Renderer,
    window_size: Vector2,
    objects: std.ArrayList(*Object),
    texts: std.ArrayList(*Text),
    delta: f64,
    start_delta: u32,
    keyboard: [*c]const u8,

    pub fn init(bgcolorn: Color, wsize: Vector2) !Cobra {
        _ = c.SDL_Init(c.SDL_INIT_EVERYTHING);
        errdefer c.SDL_Quit();

        var delta: f64 = 0.1;
        var start_delta: u32 = 0;

        var objects = std.ArrayList(*Object).init(std.heap.c_allocator);
        var texts = std.ArrayList(*Text).init(std.heap.c_allocator);

        var window = try check_sdl_pointer(c.SDL_Window, c.SDL_CreateWindow("Cobra Game Engine", c.SDL_WINDOWPOS_CENTERED, c.SDL_WINDOWPOS_CENTERED, @floatToInt(c_int, wsize.x), @floatToInt(c_int, wsize.y), 0));
        errdefer c.SDL_DestroyWindow(window);

        var renderer = try check_sdl_pointer(c.SDL_Renderer, c.SDL_CreateRenderer(window, -1, c.SDL_RENDERER_ACCELERATED));

        c.SDL_PumpEvents();
        var keyboard = c.SDL_GetKeyboardState(0);

        // c.SDL_SetRenderDrawBlendMode(renderer, c.SDL_BLENDMODE_BLEND);

        return Cobra{
            .bgcolor = bgcolorn,
            .window_size = wsize,
            .window = window,
            .renderer = renderer,
            .objects = objects,
            .texts = texts,
            .delta = delta,
            .start_delta = start_delta,
            .keyboard = keyboard,
        };
    }

    pub fn quit(self: *Cobra) void {
        c.SDL_DestroyRenderer(self.renderer);
        c.SDL_DestroyWindow(self.window);
    }

    pub fn start_frame(self: *Cobra) void {
        self.start_delta = c.SDL_GetTicks();
    }

    pub fn end_frame(self: *Cobra) void {
        self.delta = @intToFloat(f64, (c.SDL_GetTicks() - self.start_delta)) / 1000.0;
    }

    pub fn add_object(self: *Cobra, object: *Object) !void {
        try self.objects.append(object);
    }

    pub fn get_object_collision(self: *Cobra, obj1: *Object, obj2: *Object) bool {
        if (obj1.*.position.x < obj2.*.position.x + obj2.*.size.x and
            obj1.*.position.x + obj1.*.size.x > obj2.*.position.x and
            obj1.*.position.y < obj2.*.position.y + obj2.*.size.y and
            obj1.*.position.y + obj1.*.size.y > obj2.*.position.y)
        {
            return true;
        }
        return false;
    }

    pub fn handle_keyboard(self: *Cobra) void {
        c.SDL_PumpEvents();
        const keyboard_tmp: [*c]const u8 = c.SDL_GetKeyboardState(0);
        self.keyboard = keyboard_tmp;
    }

    pub fn is_key_pressed(self: *Cobra, key: u8) bool {
        return self.keyboard[key] != 0;
    }

    pub fn handle_physics(self: *Cobra) void {
        for (self.objects.items) |object| {
            object.*.update_velocity(self.delta);
        }
    }

    pub fn render(self: Cobra) void {
        _ = c.SDL_SetRenderDrawColor(self.renderer, self.bgcolor.r, self.bgcolor.g, self.bgcolor.b, self.bgcolor.a);
        _ = c.SDL_RenderClear(self.renderer);
        for (self.objects.items) |object| {
            self.render_object(object);
        }
        _ = c.SDL_RenderPresent(self.renderer);
    }

    pub fn render_object(self: Cobra, object: *Object) void {
        _ = c.SDL_SetRenderDrawColor(self.renderer, object.*.color.r, object.*.color.g, object.*.color.b, object.*.color.a);
        var rect = c.SDL_Rect{ .x = @floatToInt(c_int, object.*.position.x), .y = @floatToInt(c_int, object.*.position.y), .w = @floatToInt(c_int, object.*.size.x), .h = @floatToInt(c_int, object.*.size.y) };
        _ = c.SDL_RenderFillRect(self.renderer, &rect);
    }

    pub fn check_sdl_pointer(comptime T: type, ptr: ?*T) !*T {
        if (ptr == null)
            return error.NullSdlPointer;
        return ptr.?;
    }
};
