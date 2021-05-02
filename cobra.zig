const std = @import("std");
usingnamespace @import("./color.zig");
usingnamespace @import("./vector2.zig");
const c = @cImport({
    @cInclude("SDL.h");
});

pub const Cobra = struct {
    window: *c.SDL_Window,
    bgcolor: Color,
    renderer: *c.SDL_Renderer,
    window_size: Vector2,

    pub fn init(bgcolorn : Color, wsize : Vector2) Cobra {
        _ = c.SDL_Init(c.SDL_INIT_EVERYTHING);
        errdefer c.SDL_Quit();

        var window = try check_sdl_pointer( c.SDL_Window, c.SDL_CreateWindow("Cobra Game Engine", c.SDL_WINDOWPOS_CENTERED, c.SDL_WINDOWPOS_CENTERED, @floatToInt(i32, wsize.x), @floatToInt(i32, wsize.y), 0) );
        errdefer c.SDL_DestroyWindow(window);

        var renderer = try check_sdl_pointer( c.SDL_Renderer, c.SDL_CreateRenderer(window, -1, c.SDL_RENDERER_ACCELERATED) );

        c.SDL_SetRenderDrawBlendMode(self.renderer, c.SDL_BLENDMODE_BLEND);
        return .{
            .bgcolor = bgcolorn,
            .window_size = wsize,
            .window = window,
            .renderer = renderer,
        };
    }


    pub fn check_sdl_pointer(comptime T: type, ptr: ?*T) !*T {
        if( ptr == null )
            return error.NullSdlPointer;

        return ptr.?;
    }
};
