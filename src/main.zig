const std = @import("std");
const sqlite = @import("sqlite");
const db = @import("./db/db.zig");

const qc = @cImport({
    @cInclude("./quickjs.h");
    @cInclude("./quickjs-libc.h");
});

pub fn main() !void {
    const rt = qc.JS_NewRuntime();

    const ctx = qc.JS_NewContext(rt);

    qc.js_std_eval_binary(ctx, "'use_xyz'     ", 9, 0);

    const instance = db.DB.new();
    try instance.run_migration();
}

test "simple test" {}
