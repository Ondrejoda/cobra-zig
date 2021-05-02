pub const Color = struct {
    r: i32,
    g: i32,
    b: i32,
    a: i32,

    pub fn init(rn: i32, gn: i32, bn: i32, an: i32) Color {
        return .{
            .r = rn,
            .g = gn,
            .b = bn,
            .a = an,
        };
    }
};
