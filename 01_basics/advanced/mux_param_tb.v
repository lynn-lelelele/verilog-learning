// 文件名   ：mux_param_tb.v
// 内容     ：同时测试 4 位和 8 位两个参数化 MUX 实例
// 对应笔记 ：notes/15-参数化模块.md
// 编译     ：iverilog -o mux_param.vvp mux_param.v mux_param_tb.v
// 运行     ：vvp mux_param.vvp

`timescale 1ns/1ps // 时间单位 1ns，精度 1ps

module mux_param_tb; // 测试台模块：没有端口，只负责产生激励和检查输出

    reg [3:0] d0_4; // 4 位 MUX 的 0 号输入
    reg [3:0] d1_4; // 4 位 MUX 的 1 号输入
    reg [7:0] d0_8; // 8 位 MUX 的 0 号输入
    reg [7:0] d1_8; // 8 位 MUX 的 1 号输入
    reg       sel;  // 两个实例共用的选择信号

    wire [3:0] y_4; // 4 位 MUX 的输出
    wire [7:0] y_8; // 8 位 MUX 的输出

    mux_param #( // 开始参数覆盖列表
        .WIDTH(4)   // 覆盖默认参数：这个实例生成 4 位硬件
    ) u_mux4 (     // 参数列表结束，开始 4 位实例的端口连接
        .d0(d0_4),  // 连接 4 位 0 号输入
        .d1(d1_4),  // 连接 4 位 1 号输入
        .sel(sel),  // 连接公共选择信号
        .y(y_4)     // 连接 4 位输出
    );              // 4 位实例例化结束

    mux_param u_mux8 ( // 不覆盖参数：使用默认 WIDTH=8，生成 8 位硬件
        .d0(d0_8),  // 连接 8 位 0 号输入
        .d1(d1_8),  // 连接 8 位 1 号输入
        .sel(sel),  // 连接公共选择信号
        .y(y_8)     // 连接 8 位输出
    );              // 8 位实例例化结束

    initial begin // 主激励块：先准备数据，再分别测试 sel=0 和 sel=1
        d0_4 = 4'hA; // 4 位十六进制 A，也就是二进制 1010
        d1_4 = 4'h5; // 4 位十六进制 5，也就是二进制 0101
        d0_8 = 8'hA5; // 8 位十六进制 A5，也就是二进制 10100101
        d1_8 = 8'h5A; // 8 位十六进制 5A，也就是二进制 01011010

        sel = 1'b0; // sel=0：两个 MUX 都应该选择 d0
        #10;        // 等 10ns，让组合逻辑输出稳定

        $display("WIDTH=4  sel=0  y=%b", y_4); // 打印 4 位 MUX 的选择结果
        $display("WIDTH=8  sel=0  y=%b", y_8); // 打印 8 位 MUX 的选择结果

        if (y_4 !== 4'hA || y_8 !== 8'hA5) // 检查 sel=0 时是否选对 d0
            $display("FAIL: sel=0 输出错误"); // 条件有误时打印失败信息
        else            // 如果前面的检查条件不成立
            $display("PASS: sel=0 输出正确"); // 条件正确时打印通过信息

        sel = 1'b1; // sel=1：两个 MUX 都应该选择 d1
        #10;        // 再等 10ns，让输出重新稳定

        $display("WIDTH=4  sel=1  y=%b", y_4); // 打印换成 d1 后的 4 位结果
        $display("WIDTH=8  sel=1  y=%b", y_8); // 打印换成 d1 后的 8 位结果

        if (y_4 !== 4'h5 || y_8 !== 8'h5A) // 检查 sel=1 时是否选对 d1
            $display("FAIL: sel=1 输出错误"); // 条件有误时打印失败信息
        else            // 如果前面的检查条件不成立
            $display("PASS: sel=1 输出正确"); // 条件正确时打印通过信息

        $finish; // 测试完成，结束仿真
    end // 主激励块结束

endmodule // 测试台模块结束
