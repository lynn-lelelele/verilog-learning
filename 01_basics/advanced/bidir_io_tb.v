// 文件名   ：bidir_io_tb.v
// 内容     ：测试三态端口的四种状态：DUT 驱动、外部驱动、全部释放
// 对应笔记 ：notes/17-三态门与inout.md
// 编译     ：iverilog -o bidir_io.vvp bidir_io.v bidir_io_tb.v
// 运行     ：vvp bidir_io.vvp

`timescale 1ns/1ps // 时间单位 1ns，精度 1ps

module bidir_io_tb; // 测试台模块：模拟 DUT 和外部设备共享一根总线

    reg tx_data; // DUT 想发送的数据
    reg tx_en; // DUT 是否驱动总线
    reg ext_data; // 外部设备想发送的数据
    reg ext_en; // 外部设备是否驱动总线

    wire io; // 共享双向总线
    wire rx_data; // DUT 从总线读到的数据

    assign io = ext_en ? ext_data : 1'bz; // 测试台模拟外部设备：只有 ext_en=1 时驱动 io

    bidir_io u_dut ( // 实例化被测试的三态模块
        .tx_data(tx_data), // 连接 DUT 发送数据
        .tx_en(tx_en), // 连接 DUT 发送使能
        .rx_data(rx_data), // 连接 DUT 接收数据
        .io(io) // 连接共享总线
    ); // DUT 实例例化结束

    initial begin // 主激励块：依次观察谁在驱动总线
        tx_data = 1'b1; // DUT 准备发送 1
        tx_en = 1'b1; // DUT 打开输出
        ext_data = 1'b0; // 外部数据先设为 0
        ext_en = 1'b0; // 外部设备先松开总线
        #10; // 等 10ns，让总线稳定

        $display("DUT 驱动 1: io=%b rx=%b", io, rx_data); // 打印 DUT 驱动 1 时的总线值
        if (io !== 1'b1 || rx_data !== 1'b1) // 检查 io 和 rx_data 是否都为 1
            $display("FAIL: DUT 驱动 1 失败"); // 结果不对时打印失败
        else // 如果检查条件不成立
            $display("PASS: DUT 驱动 1 正确"); // 结果正确时打印通过

        tx_data = 1'b0; // DUT 改成发送 0
        #10; // 等 10ns，让新值稳定

        $display("DUT 驱动 0: io=%b rx=%b", io, rx_data); // 打印 DUT 驱动 0 时的总线值
        if (io !== 1'b0 || rx_data !== 1'b0) // 检查 io 和 rx_data 是否都为 0
            $display("FAIL: DUT 驱动 0 失败"); // 结果不对时打印失败
        else // 如果检查条件不成立
            $display("PASS: DUT 驱动 0 正确"); // 结果正确时打印通过

        tx_en = 1'b0; // DUT 释放总线，输出变成 z
        ext_en = 1'b1; // 外部设备开始驱动总线
        ext_data = 1'b1; // 外部设备发送 1
        #10; // 等 10ns，让外部数据传到 io

        $display("外部驱动 1: io=%b rx=%b", io, rx_data); // 打印外部设备驱动 1 时 DUT 读到的值
        if (io !== 1'b1 || rx_data !== 1'b1) // 检查 DUT 是否读到了外部 1
            $display("FAIL: DUT 读取外部 1 失败"); // 结果不对时打印失败
        else // 如果检查条件不成立
            $display("PASS: DUT 读取外部 1 正确"); // 结果正确时打印通过

        ext_en = 1'b0; // 外部设备也释放总线
        #10; // 等 10ns，观察无人驱动时的值

        $display("全部释放: io=%b rx=%b", io, rx_data); // 打印无人驱动时的总线值
        if (io !== 1'bz || rx_data !== 1'bz) // 检查总线是否进入高阻 z
            $display("FAIL: 总线没有进入高阻"); // 结果不对时打印失败
        else // 如果检查条件不成立
            $display("PASS: 总线进入高阻"); // 结果正确时打印通过

        $finish; // 测试完成，结束仿真
    end // 主激励块结束

endmodule // 测试台模块结束
