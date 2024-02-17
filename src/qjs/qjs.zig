const qc = @cImport({
    @cInclude("./quickjs.h");
    @cInclude("./quickjs-libc.h");
});

pub fn run() !void {
    const rt = qc.JS_NewRuntime();
    const ctx = qc.JS_NewContext(rt);

    qc.js_std_eval_binary(ctx, "'use_xyz'     ", 9, 0);
}
