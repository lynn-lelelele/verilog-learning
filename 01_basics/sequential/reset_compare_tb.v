// 文件名   ：reset_compare_tb.v
// 内容     ：同步复位 vs 异步复位 的对比测试台
// 被测模块 ：counter4（同步）、counter4_async（异步）
// 编译     ：iverilog -o reset.vvp counter4.v counter4_async.v reset_compare_tb.v
// 运行     ：vvp reset.vvp
//
// 思路：让两个计数器跑同样的时钟、同样的 rst，只在关键时刻观察差别。
//   时钟周期 10，上升沿出现在 t = 5, 15, 25, 35, 45, 55 ...
//   t=0~12   先复位，让两个计数器都从 0 开始（否则初值是 x）
//   t=12     放开复位，开始计数：15→1, 25→2, 35→3
//   t=38     在两个上升沿中间拉高 rst（关键动作）
//   t=41     观察：异步已经清零，同步还停在 3
//   t=48     放开复位
//   t=57     观察：两者都从 1 重新开始
//
// 预期输出：
//   t=36  同步 q=3   异步 q=3
//   t=41  同步 q=3   异步 q=0   ← 异步立刻清零
//   t=57  同步 q=1   异步 q=1

module reset_compare_tb;

    reg        clk;
    reg        rst;
    wire [3:0] q_sync;     // 同步复位计数器的输出
    wire [3:0] q_async;    // 异步复位计数器的输出

    counter4       u_sync  ( .clk(clk), .rst(rst), .q(q_sync)  );
    counter4_async u_async ( .clk(clk), .rst(rst), .q(q_async) );

    // 时钟：每 5 个时间单位翻转 → 周期 10
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // 激励
    initial begin
        rst = 1'b1;           // 上电先复位，避免 q 保持 x
        #12;                  // t=12：经过 t=5 的沿，q 已被清成 0
        rst = 1'b0;           // 放开复位，开始计数

        #24;                  // t=36：此时已计到 3
        $display("---- t=36  复位前 ----");
        $display("  同步 q=%0d   异步 q=%0d", q_sync, q_async);

        #2;                   // t=38：故意选在两个上升沿（35 与 45）之间
        rst = 1'b1;

        #3;                   // t=41：还没到下一个沿，但异步已经响应
        $display("---- t=41  rst 拉高后（无时钟沿）----");
        $display("  同步 q=%0d   异步 q=%0d   ← 异步立刻清零", q_sync, q_async);

        #7;                   // t=48
        rst = 1'b0;

        #9;                   // t=57：经过 t=55 的沿
        $display("---- t=57  复位放开后 ----");
        $display("  同步 q=%0d   异步 q=%0d", q_sync, q_async);

        $finish;
    end

endmodule
