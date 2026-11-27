// 文件名   ：bidir_io.v
// 内容     ：三态双向端口示例；同一根 io 既能输出，也能读取外部驱动
// 对应笔记 ：notes/17-三态门与inout.md
// 编译     ：iverilog -o bidir_io.vvp bidir_io.v bidir_io_tb.v

module bidir_io (
    input      tx_data,  // 本模块要发送的数据
    input      tx_en,    // 发送使能：1=驱动总线，0=释放总线
    output     rx_data,  // 从总线读回来的数据
    inout wire io        // 双向引脚：既可能是输出，也可能是输入
);

    // tx_en=1：把 tx_data 驱动到 io；
    // tx_en=0：输出 1'bz（高阻），相当于“松开这根线”，让别的设备驱动。
    assign io = tx_en ? tx_data : 1'bz;

    // io 是 wire，可以直接读取当前总线电平。
    // 本模块驱动时读到自己的值；本模块释放时读到外部设备的值。
    assign rx_data = io;

endmodule