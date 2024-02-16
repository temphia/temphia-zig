const std = @import("std");
const sqlite = @import("sqlite");
const db = @import("./db/db.zig");

pub fn main() !void {
    const instance = db.DB.new();
    try instance.run_migration();
}

test "simple test" {}
