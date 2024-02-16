const std = @import("std");
const sqlite = @import("sqlite");

pub fn main() !void {
    std.debug.print("Starting temphia.\n", .{});

    var db = try sqlite.Db.init(.{
        .mode = sqlite.Db.Mode{ .File = "zig-out/data.db" },
        .open_flags = .{
            .write = true,
            .create = true,
        },
        .threading_mode = .MultiThread,
    });

    const query =
        \\ CREATE TABLE contacts (
        \\ contact_id INTEGER PRIMARY KEY,
        \\ first_name TEXT NOT NULL,
        \\ last_name TEXT NOT NULL,
        \\ email TEXT NOT NULL UNIQUE,
        \\ phone TEXT NOT NULL UNIQUE
        \\);
    ;

    var stmt = try db.prepare(query);

    try stmt.exec(.{}, .{});

    defer stmt.deinit();
}

test "simple test" {}
