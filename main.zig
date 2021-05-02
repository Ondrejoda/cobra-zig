const std = @import("std");
usingnamespace @import("./cobra.zig");
usingnamespace @import("./color.zig");
usingnamespace @import("./vector2.zig");
usingnamespace @import("./object.zig");
const c = @cImport({
    @cInclude("SDL.h");
});

pub fn main() anyerror!void {
    var bgcolor : Color = Color.init(0, 0, 0, 255);
    var wsize : Vector2 = Vector2.init(200, 200);

    var engine : Cobra = try Cobra.init(bgcolor, wsize);

    var obj : Object = Object.init(Vector2.init(0, 0), Vector2.init(100, 100), Color.init(255, 255, 255, 255), 0);
    engine.add_object(&obj);

    while (true) {
        engine.render();
    }
}
