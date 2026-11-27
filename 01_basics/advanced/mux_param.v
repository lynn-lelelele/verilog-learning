// 文件名   ：mux_param.v
// 内容     ：参数化 2 选 1 选择器；WIDTH 决定输入和输出是多少位
// 对应笔记 ：notes/15-参数化模块.md
// 编译     ：iverilog -o mux_param.vvp mux_param.v mux_param_tb.v
//
// 这个模块的重点不是 MUX，而是 #(parameter WIDTH = 8)：
//   WIDTH 不是运行时信号，而是模块被“展开”时的常量。
//   例化时给 WIDTH=4，就生成一个 4 位 MUX；
//   例化时给 WIDTH=8，就生成一个 8 位 MUX。

module mux_param #(
    parameter WIDTH = 8          // 默认宽度是 8；例化时可以用 #(.WIDTH(...)) 覆盖
) (
    input  [WIDTH-1:0] d0,       // 0 号输入：宽度由 WIDTH 决定
    input  [WIDTH-1:0] d1,       // 1 号输入：宽度同样由 WIDTH 决定
    input              sel,      // 选择信号：0 选 d0，1 选 d1
    output [WIDTH-1:0] y         // 输出：宽度跟随 WIDTH
);

    // sel=0 时 y=d0；sel=1 时 y=d1。
    // 这是组合逻辑，所以 y 会随着 d0、d1、sel 的变化重新计算；
    // 只有值真的不同时，波形上的 y 才会变化。
    assign y = sel ? d1 : d0;

endmodule