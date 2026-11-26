// 文件名   ：mux4_tb.v
// 内容     ：4 选 1 多路选择器的测试台，同时测 case 与 if-else 两个版本
// 被测模块 ：mux4_case、mux4_if
// 编译     ：iverilog -o mux4.vvp mux4.v mux4_tb.v
// 运行     ：vvp mux4.vvp
//
// 预期输出（d 固定为 1010，sel 依次 00/01/10/11）：
//   d=1010 sel=00 -> case_y=0 if_y=0
//   d=1010 sel=01 -> case_y=1 if_y=1
//   d=1010 sel=10 -> case_y=0 if_y=0
//   d=1010 sel=11 -> case_y=1 if_y=1
// 再把 d 换成 0110：
//   d=0110 sel=00 -> case_y=0 if_y=0
//   d=0110 sel=01 -> case_y=1 if_y=1
//   d=0110 sel=10 -> case_y=1 if_y=1
//   d=0110 sel=11 -> case_y=0 if_y=0

// 说明：
//   d 固定不变、只改 sel，就能看出“同样的数据、不同选择”输出的差别；
//   第二组把 d 换成 0110，验证两种写法不是只会对某一组数据碰巧正确。

module mux4_tb;

    reg  [3:0] d;        // 激励：4 路数据，由测试台赋值
    reg  [1:0] sel;      // 激励：选择信号，决定输出哪一路

    wire case_y;         // 观察：case 版本的输出
    wire if_y;           // 观察：if-else 版本的输出

    // 两块电路并排，输入接同一组开关，输出分开观察
    mux4_case u_case ( .d(d), .sel(sel), .y(case_y) );
    mux4_if   u_if   ( .d(d), .sel(sel), .y(if_y)   );

    initial begin
        // ---- 第一轮：d = 1010，四路数据分别是 d[3]=1 d[2]=0 d[1]=1 d[0]=0 ----
        d = 4'b1010;

        sel = 2'b00; #10;    // 选 d[0] = 0
        $display("d=%b sel=%b -> case_y=%b if_y=%b", d, sel, case_y, if_y);

        sel = 2'b01; #10;    // 选 d[1] = 1
        $display("d=%b sel=%b -> case_y=%b if_y=%b", d, sel, case_y, if_y);

        sel = 2'b10; #10;    // 选 d[2] = 0
        $display("d=%b sel=%b -> case_y=%b if_y=%b", d, sel, case_y, if_y);

        sel = 2'b11; #10;    // 选 d[3] = 1
        $display("d=%b sel=%b -> case_y=%b if_y=%b", d, sel, case_y, if_y);

        // ---- 第二轮：d = 0110，验证换数据后两种写法仍然一致 ----
        d = 4'b0110;

        sel = 2'b00; #10;    // 选 d[0] = 0
        $display("d=%b sel=%b -> case_y=%b if_y=%b", d, sel, case_y, if_y);

        sel = 2'b01; #10;    // 选 d[1] = 1
        $display("d=%b sel=%b -> case_y=%b if_y=%b", d, sel, case_y, if_y);

        sel = 2'b10; #10;    // 选 d[2] = 1
        $display("d=%b sel=%b -> case_y=%b if_y=%b", d, sel, case_y, if_y);

        sel = 2'b11; #10;    // 选 d[3] = 0
        $display("d=%b sel=%b -> case_y=%b if_y=%b", d, sel, case_y, if_y);

        $finish;
    end

endmodule
