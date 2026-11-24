// ============================================================
// 文件名   ：full_adder_tb.v
// 内容     ：全加器测试台，穷举 a、b、cin 的 8 种组合
// 对应笔记 ：notes/10-全加器.md
// 运行     ：iverilog -o fa.vvp half_adder.v full_adder.v full_adder_tb.v
//            vvp fa.vvp
// 预期输出 ：
//   a=0 b=0 cin=0 | sum=0 cout=0
//   a=0 b=0 cin=1 | sum=1 cout=0
//   a=0 b=1 cin=0 | sum=1 cout=0
//   a=0 b=1 cin=1 | sum=0 cout=1
//   a=1 b=0 cin=0 | sum=1 cout=0
//   a=1 b=0 cin=1 | sum=0 cout=1
//   a=1 b=1 cin=0 | sum=0 cout=1
//   a=1 b=1 cin=1 | sum=1 cout=1
// ============================================================

module full_adder_tb;

    reg  a, b, cin;         // 三个输入由测试台拨动，所以是 reg
    wire sum, cout;         // 两个输出由被测电路驱动，所以是 wire

    // 实例化全加器，端口按名字连接
    full_adder dut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    initial begin
        // 用三层循环穷举 2 × 2 × 2 = 8 种组合
        // 每次先赋值、等 10 个时间单位让电路稳定，再打印
        a = 0; b = 0; cin = 0; #10;
        $display("a=%b b=%b cin=%b | sum=%b cout=%b", a, b, cin, sum, cout);

        a = 0; b = 0; cin = 1; #10;
        $display("a=%b b=%b cin=%b | sum=%b cout=%b", a, b, cin, sum, cout);

        a = 0; b = 1; cin = 0; #10;
        $display("a=%b b=%b cin=%b | sum=%b cout=%b", a, b, cin, sum, cout);

        a = 0; b = 1; cin = 1; #10;
        $display("a=%b b=%b cin=%b | sum=%b cout=%b", a, b, cin, sum, cout);

        a = 1; b = 0; cin = 0; #10;
        $display("a=%b b=%b cin=%b | sum=%b cout=%b", a, b, cin, sum, cout);

        a = 1; b = 0; cin = 1; #10;
        $display("a=%b b=%b cin=%b | sum=%b cout=%b", a, b, cin, sum, cout);

        a = 1; b = 1; cin = 0; #10;
        $display("a=%b b=%b cin=%b | sum=%b cout=%b", a, b, cin, sum, cout);

        a = 1; b = 1; cin = 1; #10;
        $display("a=%b b=%b cin=%b | sum=%b cout=%b", a, b, cin, sum, cout);

        $finish;
    end

endmodule
