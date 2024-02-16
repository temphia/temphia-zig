const std = @import("std");
const sqlite = @import("sqlite");
const Schema = @embedFile("./schema.sql");

pub const DB = struct {
    const Self = @This();

    pub fn new() Self {
        return Self{};
    }

    pub fn run_migration(_: Self) !void {
        std.debug.print("Starting temphia.\n", .{});

        var db = try sqlite.Db.init(.{
            .mode = sqlite.Db.Mode{ .File = "zig-out/data.db" },
            .open_flags = .{
                .write = true,
                .create = true,
            },
            .threading_mode = .MultiThread,
        });

        var stmt = try db.prepare(Schema);

        try stmt.exec(.{}, .{});

        defer stmt.deinit();
    }
};

test "simple test" {}
