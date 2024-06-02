const gl = @import("gl");

// Vertex Buffer Object (VBO), holds vertex data.
var vbo: c_uint = undefined;
const verts = [_]f32{ -0.5, -0.5, 0.0, 0.5, -0.5, 0.0, 0.0, 0.5, 0.0 };

pub fn init() anyerror!void {
    gl.GenBuffers(1, (&vbo)[0..1]);

    gl.BindBuffer(gl.ARRAY_BUFFER, vbo);

    gl.BufferData(
        gl.ARRAY_BUFFER,
        @sizeOf(f32),
        &verts,
        gl.STATIC_DRAW,
    );

    // Issue OpenGL commands to your heart's content!
    const alpha: gl.float = 1;
    gl.ClearColor(1, 0.5, 0.5, alpha);
}

pub fn main_loop() void {
    gl.Clear(gl.COLOR_BUFFER_BIT);
    gl.DrawArrays(gl.TRIANGLES, 0, verts.len);
}

pub fn cleanup() void {
    gl.BindBuffer(gl.ARRAY_BUFFER, 0);
    gl.DeleteBuffers(1, (&vbo)[0..1]);
}
