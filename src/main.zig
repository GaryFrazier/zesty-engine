const std = @import("std");
const gl = @import("gl");
const glfw = @import("mach-glfw");
const window_service = @import("./engine/window_service.zig");
const render_service = @import("./engine/render_service.zig");

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const window = try allocator.create(glfw.Window);
    defer allocator.destroy(window);
    init(window);

    // Wait for the user to close the window.
    while (!window.shouldClose()) {
        window_service.main_loop(window);
        render_service.main_loop();
    }

    cleanup(window);
}

pub fn init(window: *glfw.Window) void {
    window.* = window_service.init() catch |err| {
        std.log.err("failed to create window via window_service: {}", .{err});
        std.process.exit(1);
    };

    render_service.init() catch |err| {
        std.log.err("failed to init rendering data via render_service: {}", .{err});
        std.process.exit(1);
    };
}

pub fn cleanup(window: *glfw.Window) void {
    render_service.cleanup();
    window_service.cleanup(window);
}
