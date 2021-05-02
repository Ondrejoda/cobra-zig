pub const Vector2 = struct {
    x: f64,
    y: f64,

    pub fn init(xn: f64, yn: f64) Vector2 {
        return .{
            .x = xn,
            .y = yn,
        };
    }
};
