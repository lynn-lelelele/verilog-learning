// 文件名   ：adder_param.v
// 内容     ：参数化行波进位加法器，用 generate for 生成 WIDTH 个全加器
// 对应笔记 ：notes/16-generate-for.md
// 依赖     ：../modules/half_adder.v、../modules/full_adder.v
// 编译     ：iverilog -o adder_param.vvp ../modules/half_adder.v ../modules/full_adder.v adder_param.v adder_param_tb.v

module adder_param #(
    parameter WIDTH = 4          // 加法器位数；默认 4 位，例化时可以覆盖
) (
    input  [WIDTH-1:0] a,        // 被加数
    input  [WIDTH-1:0] b,        // 加数
    input              cin,      // 最低位进位输入
    output [WIDTH-1:0] sum,      // 本位和
    output             cout      // 最高位进位输出
);

    // carry[0] 是最低位输入 cin；
    // carry[1] 是第 0 位的进位；
    // ……
    // carry[WIDTH] 是最高位送出的 cout。
    wire [WIDTH:0] carry;

    assign carry[0] = cin;       // 把外部 cin 接到进位链的起点

    genvar i;                    // genvar 是“展开硬件时”使用的循环变量，不是运行时信号

    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : gen_full_adders
            // 这一行会被展开 WIDTH 次：WIDTH=4 就生成 4 个 full_adder。
            // a[i]、b[i]、sum[i] 每次取当前这一位；
            // carry[i] 来自低位，carry[i+1] 送给高位。
            full_adder u_fa (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    assign cout = carry[WIDTH];  // 最高位产生的进位就是整个加法器的 cout

endmodule