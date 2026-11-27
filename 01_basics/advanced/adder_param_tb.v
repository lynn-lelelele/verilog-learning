// 文件名   ：adder_param_tb.v
// 内容     ：测试 4 位和 8 位参数化行波进位加法器
// 对应笔记 ：notes/16-generate-for.md
// 编译     ：iverilog -o adder_param.vvp ../modules/half_adder.v ../modules/full_adder.v adder_param.v adder_param_tb.v
// 运行     ：vvp adder_param.vvp

`timescale 1ns/1ps // 时间单位 1ns，精度 1ps

module adder_param_tb; // 测试台模块：产生输入并检查两个加法器实例

    reg [3:0] a4; // 4 位加法器的 a 输入
    reg [3:0] b4; // 4 位加法器的 b 输入
    reg [7:0] a8; // 8 位加法器的 a 输入
    reg [7:0] b8; // 8 位加法器的 b 输入
    reg       cin; // 两个实例共用的最低位进位

    wire [3:0] sum4; // 4 位加法器的和
    wire       cout4; // 4 位加法器的最高位进位
    wire [7:0] sum8; // 8 位加法器的和
    wire       cout8; // 8 位加法器的最高位进位

    adder_param #( // 开始参数覆盖列表
        .WIDTH(4) // 覆盖默认参数：生成 4 位加法器
    ) u_add4 ( // 参数列表结束，开始 4 位实例端口连接
        .a(a4), // 连接 4 位 a
        .b(b4), // 连接 4 位 b
        .cin(cin), // 连接公共进位输入
        .sum(sum4), // 连接 4 位和
        .cout(cout4) // 连接 4 位最高进位
    ); // 当前实例例化结束

    adder_param #( // 开始参数覆盖列表
        .WIDTH(8) // 覆盖默认参数：生成 8 位加法器
    ) u_add8 ( // 参数列表结束，开始 8 位实例端口连接
        .a(a8), // 连接 8 位 a
        .b(b8), // 连接 8 位 b
        .cin(cin), // 连接公共进位输入
        .sum(sum8), // 连接 8 位和
        .cout(cout8) // 连接 8 位最高进位
    ); // 当前实例例化结束

    initial begin // 主激励块：测试普通加法和最高位进位
        cin = 1'b0; // 先把最低位进位设为 0
        a4 = 4'h3; // 4 位测试：3
        b4 = 4'h5; // 4 位测试：5
        a8 = 8'hA5; // 8 位测试：A5
        b8 = 8'h5A; // 8 位测试：5A
        #10; // 等 10ns，让组合加法器输出稳定

        $display("4-bit  3 + 5 = %h, cout=%b", sum4, cout4); // 打印 3+5 的结果
        $display("8-bit A5 + 5A = %h, cout=%b", sum8, cout8); // 打印 A5+5A 的结果
        if (sum4 !== 4'h8 || cout4 !== 1'b0 || sum8 !== 8'hFF || cout8 !== 1'b0) // 检查普通加法
            $display("FAIL: 普通加法结果错误"); // 结果不对时打印失败
        else // 如果上面的条件不成立
            $display("PASS: 普通加法结果正确"); // 结果正确时打印通过

        a4 = 4'hF; // 4 位测试：让 F + 1 产生最高位进位
        b4 = 4'h1; // 4 位测试：1
        a8 = 8'hA5; // 8 位测试：A5
        b8 = 8'h6A; // 8 位测试：6A
        cin = 1'b1; // 再加一个最低位进位，制造 8 位溢出
        #10; // 等 10ns，让新输入传播完成

        $display("4-bit  F + 1 + %b = %h, cout=%b", cin, sum4, cout4); // 打印 4 位溢出结果
        $display("8-bit A5 + 6A + %b = %h, cout=%b", cin, sum8, cout8); // 打印 8 位溢出结果
        if (sum4 !== 4'h1 || cout4 !== 1'b1 || sum8 !== 8'h10 || cout8 !== 1'b1) // 检查进位是否正确
            $display("FAIL: 进位结果错误"); // 结果不对时打印失败
        else // 如果上面的条件不成立
            $display("PASS: 进位结果正确"); // 结果正确时打印通过

        $finish; // 测试完成，结束仿真
    end // 主激励块结束

endmodule // 测试台模块结束
