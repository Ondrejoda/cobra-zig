pub const Color = struct {
    r: u8,
    g: u8,
    b: u8,
    a: u8,

    pub fn init(rn: u8, gn: u8, bn: u8, an: u8) Color {
        return .{
            .r = rn,
            .g = gn,
            .b = bn,
            .a = an,
        };
    }
};
