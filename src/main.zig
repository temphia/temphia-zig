const std = @import("std");
const sqlite = @import("sqlite");
const db = @import("./db/db.zig");
const qjs = @import("./qjs//qjs.zig");

pub fn main() !void {
    const instance = db.DB.new();
    try instance.run_migration();

    try qjs.run();
}

test "simple test" {}
