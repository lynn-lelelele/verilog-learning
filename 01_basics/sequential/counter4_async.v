// 文件名   ：counter4_async.v
// 内容     ：4 位异步复位计数器，用来和 counter4.v（同步复位）对比
// 对应笔记 ：notes/12-时钟与触发器.md 第 5 节
// 编译     ：iverilog -o reset.vvp counter4.v counter4_async.v reset_compare_tb.v
//
// 唯一区别：敏感列表里多了 “or posedge rst”。
//   同步版：always @(posedge clk)                → rst 变化本身不触发块
//   异步版：always @(posedge clk or posedge rst) → rst 上升沿也触发块，且立刻执行

module counter4_async (
    input           clk,
    input           rst,
    output reg [3:0] q
);

    // 逐行拆解（和同步版逐行对照，只有第一行不同）：
    //
    //   always @(posedge clk or posedge rst) begin
    //     │       │            │  └ rst 从 0 变 1 的瞬间也唤醒本块 → 所以“立刻”
    //     │       │            └ or：两个事件“或”，任意一个发生都执行
    //     │       └ posedge clk：时钟上升沿照常唤醒
    //     └ always：过程块
    //
    //   if (rst) q <= 4'd0;
    //     └ 被 rst 唤醒时 rst 必然为 1，所以立刻清零，不需要等时钟
    //
    //   else     q <= q + 1'b1;
    //     └ 只有 rst 为 0 才计数；rst 为 1 时这一行被跳过（复位优先级最高）
    always @(posedge clk or posedge rst) begin
        if (rst) q <= 4'd0;      // 复位：拉高瞬间清零
        else     q <= q + 1'b1;  // 正常计数
    end                          // 块体结束

endmodule


// ---------------------------------------------------------------------------
// 与同步版 counter4.v 的唯一区别就是敏感列表：
//   counter4.v       : always @(posedge clk)
//   counter4_async.v : always @(posedge clk or posedge rst)
// 按方法学建议，实际项目里应再配“异步复位、同步释放”，
// 见 notes/12-时钟与触发器.md 第 5.5 节。
// ---------------------------------------------------------------------------
