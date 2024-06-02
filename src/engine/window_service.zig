const std = @import("std");
const gl = @import("gl");
const glfw = @import("mach-glfw");

// Procedure table that will hold OpenGL functions loaded at runtime.
var procs: gl.ProcTable = undefined;

/// Default GLFW error handling callback
fn errorCallback(error_code: glfw.ErrorCode, description: [:0]const u8) void {
    std.log.err("glfw: {}: {s}\n", .{ error_code, description });
}

pub fn init() anyerror!glfw.Window {
    glfw.setErrorCallback(errorCallback);

    if (!glfw.init(.{})) {
        std.log.err("Failed to initialize GLFW: {?s}", .{glfw.getErrorString()});
        std.process.exit(1);
    }

    // Create our window
    const window = glfw.Window.create(640, 480, "Hello, mach-glfw!", null, null, .{}) orelse {
        std.log.err("failed to create GLFW window: {?s}", .{glfw.getErrorString()});
        std.process.exit(1);
    };

    // Make the window's OpenGL context current.
    glfw.makeContextCurrent(window);

    // Enable VSync to avoid drawing more often than necessary.
    glfw.swapInterval(1);

    // Initialize the procedure table.
    if (!procs.init(glfw.getProcAddress)) {
        return error.InitFailed;
    }

    // Make the procedure table current on the calling thread.
    gl.makeProcTableCurrent(&procs);

    return window;
}

pub fn main_loop(window: *glfw.Window) void {
    window.swapBuffers();
    glfw.pollEvents();
}

pub fn cleanup(window: *glfw.Window) void {
    gl.makeProcTableCurrent(null);
    glfw.makeContextCurrent(null);
    window.destroy();
    glfw.terminate();
}
