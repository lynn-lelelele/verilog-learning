// 文件名   ：seq_detect1011_mealy.v
// 内容     ：序列检测器的 Mealy 版：输出 = 当前状态 + 输入，命中当拍就拉高
// 对应笔记 ：notes/13-有限状态机.md 第 7 节（Moore vs Mealy）
// 编译     ：iverilog -o fsm.vvp seq_detect1011.v seq_detect1011_mealy.v seq_detect_tb.v
// 依赖     ：无
//
// 和 Moore 版的区别只有两处：
//   1. 只有 4 个状态：不需要 S4。因为“命中”这件事由输入 din 直接决定，
//      不用再花一个状态去记住“我刚才已经命中了”。
//   2. 输出多了一项 && din。
//
// 为什么能省掉一个状态：
//   Moore 的输出函数只有 state 一个参数，命中信息必须存在状态里 → 需要 S4。
//   Mealy 的输出函数是 λ(state, din)，(S3, din=1) 这个组合本身就代表命中，
//   所以 S3 收到 1 的那一刻就能输出，状态只需要记到“已匹配 101”为止。
//
// 代价：输出是组合逻辑，din 一变输出就可能跟着抖（组合毛刺），
//       而且它比 Moore 早一拍——这一点在波形上看得最清楚。

module seq_detect1011_mealy (   // 模块开始；端口和 Moore 版完全一样
    input  clk,                // 输入：时钟
    input  rst,                // 输入：同步复位
    input  din,                // 输入：数据流
    output detected            // 输出：命中标志（组合输出，随 din 变化）
);                             // 端口表结束

    // 只需要 4 个状态，2 位就够（Moore 版需要 3 位）
    localparam [1:0] S0 = 2'd0,   // 常量：2 位宽、十进制写法、值 0
                     S1 = 2'd1,   // 已收到 "1"
                     S2 = 2'd2,   // 已收到 "10"
                     S3 = 2'd3;   // 已收到 "101"；再来 1 就当场输出

    reg [1:0] state, next_state;  // 当前状态（寄存器）与次态（组合结果）

    // 第一段：状态寄存器
    always @(posedge clk) begin          // 只在时钟上升沿执行
        if (rst) state <= S0;            // 复位：回起点
        else     state <= next_state;    // 否则搬入第二段算好的次态
    end                                  // 块结束

    // 第二段：次态逻辑（和 Moore 版前 4 条完全一样，只是没有 S4）
    always @(*) begin                    // 任何输入变化都重算
        next_state = state;              // 默认保持，防止漏分支
        case (state)                     // 用状态选“行”
            S0: next_state = din ? S1 : S0;   // 来 1 开始，来 0 原地
            S1: next_state = din ? S1 : S2;   // 再来 1 仍是 "1"，来 0 得 "10"
            S2: next_state = din ? S3 : S0;   // 来 1 得 "101"，来 0 报废
            S3: next_state = din ? S1 : S2;   // 命中后按“可重叠”规则重新起步
            default: next_state = S0;         // 越界编码一律回 S0
        endcase                          // case 结束
    end                                  // 块结束

    // 第三段：输出逻辑（Mealy）
    //   当前状态已经是 "101"，此刻 din 又是 1 → 这一拍就输出 1，
    //   不用等下一个时钟沿把它锁进 S4。
    //
    //   注意这是纯组合逻辑：(state == S3) 和 din 都为 1 时，输出立刻为 1。
    //   好处是快一拍；坏处是 din 若在沿之间抖动，输出也会跟着抖一下。
    assign detected = (state == S3) && din;

endmodule