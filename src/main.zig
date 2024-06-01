const std = @import("std");
const gl = @import("gl");
const glfw = @import("mach-glfw");

// Procedure table that will hold OpenGL functions loaded at runtime.
var procs: gl.ProcTable = undefined;

/// Default GLFW error handling callback
fn errorCallback(error_code: glfw.ErrorCode, description: [:0]const u8) void {
    std.log.err("glfw: {}: {s}\n", .{ error_code, description });
}

pub fn main() !void {
    glfw.setErrorCallback(errorCallback);

    if (!glfw.init(.{})) {
        std.log.err("Failed to initialize GLFW: {?s}", .{glfw.getErrorString()});
        std.process.exit(1);
    }
    defer glfw.terminate();

    // Create our window
    const window = glfw.Window.create(640, 480, "Hello, mach-glfw!", null, null, .{}) orelse {
        std.log.err("failed to create GLFW window: {?s}", .{glfw.getErrorString()});
        std.process.exit(1);
    };
    defer window.destroy();

    // Make the window's OpenGL context current.
    glfw.makeContextCurrent(window);
    defer glfw.makeContextCurrent(null);

    // Enable VSync to avoid drawing more often than necessary.
    glfw.swapInterval(1);

    // Initialize the procedure table.
    if (!procs.init(glfw.getProcAddress)) return error.InitFailed;

    // Make the procedure table current on the calling thread.
    gl.makeProcTableCurrent(&procs);
    defer gl.makeProcTableCurrent(null);

    const verts = [_]f32{ -0.5, -0.5, 0.0, 0.5, -0.5, 0.0, 0.0, 0.5, 0.0 };

    // Vertex Buffer Object (VBO), holds vertex data.
    var vbo: c_uint = undefined;
    gl.GenBuffers(1, (&vbo)[0..1]);
    defer gl.DeleteBuffers(1, (&vbo)[0..1]);

    gl.BindBuffer(gl.ARRAY_BUFFER, vbo);
    defer gl.BindBuffer(gl.ARRAY_BUFFER, 0);

    gl.BufferData(
        gl.ARRAY_BUFFER,
        @sizeOf(f32),
        &verts,
        gl.STATIC_DRAW,
    );

    // Wait for the user to close the window.
    while (!window.shouldClose()) {
        window.swapBuffers();
        glfw.pollEvents();
    }
}
