const std = @import("std");
usingnamespace @import("./cobra.zig");
usingnamespace @import("./color.zig");
usingnamespace @import("./vector2.zig");
const c = @cImport({
    @cInclude("SDL.h");
});

pub fn main() anyerror!void {
    var bgcolor : Color = Color.init(255, 255, 255, 255);
    var wsize : Vector2 = Vector2.init(200, 200);

    var engine : Cobra = try Cobra.init(bgcolor, wsize);
}
