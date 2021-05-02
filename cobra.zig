const std = @import("std");
usingnamespace @import("./color.zig");
usingnamespace @import("./vector2.zig");
usingnamespace @import("./object.zig");
const c = @cImport({
    @cInclude("SDL.h");
});

pub const Cobra = struct {
    window: *c.SDL_Window,
    bgcolor: Color,
    renderer: *c.SDL_Renderer,
    window_size: Vector2,
    objects: std.ArrayList(*Object),
    // var num_vector

    pub fn init(bgcolorn : Color, wsize : Vector2) !Cobra {
        _ = c.SDL_Init(c.SDL_INIT_EVERYTHING);
        errdefer c.SDL_Quit();

        var objects = std.ArrayList(*Object).init(std.heap.c_allocator);

        var window = try check_sdl_pointer( c.SDL_Window, c.SDL_CreateWindow("Cobra Game Engine", c.SDL_WINDOWPOS_CENTERED, c.SDL_WINDOWPOS_CENTERED, @floatToInt(c_int, wsize.x), @floatToInt(c_int, wsize.y), 0) );
        errdefer c.SDL_DestroyWindow(window);

        var renderer = try check_sdl_pointer( c.SDL_Renderer, c.SDL_CreateRenderer(window, -1, c.SDL_RENDERER_ACCELERATED) );

        return Cobra{
            .bgcolor = bgcolorn,
            .window_size = wsize,
            .window = window,
            .renderer = renderer,
            .objects = objects,
        };
    }

    pub fn add_object(self: *Cobra, object: *Object) void {
        try self.objects.append(object);
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
        var rect = c.SDL_Rect{.x = @floatToInt(c_int, object.*.position.x), .y = @floatToInt(c_int, object.*.position.y), .w = @floatToInt(c_int, object.*.size.x), .h = @floatToInt(c_int, object.*.size.y)};
        _ = c.SDL_RenderFillRect(self.renderer, &rect);
    }

    pub fn check_sdl_pointer(comptime T: type, ptr: ?*T) !*T {
        if( ptr == null )
            return error.NullSdlPointer;
        return ptr.?;
    }
};
