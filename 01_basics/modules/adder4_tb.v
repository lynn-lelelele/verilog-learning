// 文件名   ：adder4_tb.v
// 内容     ：4 位行波进位加法器的测试台
// 被测模块 ：adder4（内部实例化了 4 个 full_adder）
// 编译     ：iverilog -o adder4.vvp half_adder.v full_adder.v adder4.v adder4_tb.v
// 运行     ：vvp adder4.vvp
//
// 预期输出（%d 十进制，%b 二进制）：
//   a= 0 b= 0 cin=0 -> sum= 0 (0000) cout=0
//   a= 5 b= 3 cin=0 -> sum= 8 (1000) cout=0
//   a=15 b= 1 cin=0 -> sum= 0 (0000) cout=1   15+1=16，4 位装不下，溢出
//   a= 9 b= 6 cin=1 -> sum= 0 (0000) cout=1    9+6+1=16，同样溢出
//   a=10 b= 5 cin=0 -> sum=15 (1111) cout=0

module adder4_tb;

    // 激励：测试台主动赋值，所以用 reg
    reg  [3:0] a;
    reg  [3:0] b;
    reg        cin;

    // 观察：由被测电路驱动，所以用 wire
    wire [3:0] sum;
    wire       cout;

    // 实例化被测电路：a、b、cin 三个开关接进去，sum、cout 两根观察线接出来
    adder4 dut (
        .a(a), .b(b), .cin(cin),
        .sum(sum), .cout(cout)
    );

    initial begin
        // 用一个任务把“赋值 + 等待 + 打印”打包，避免重复四行
        // 注意：任务只是测试台的便利写法，不影响被测电路
        a = 4'd0;  b = 4'd0;  cin = 1'b0;  #10;
        $display("a=%2d b=%2d cin=%b -> sum=%2d (%b) cout=%b", a, b, cin, sum, sum, cout);

        // 5 + 3 = 8：普通情况，不产生最高位进位
        a = 4'd5;  b = 4'd3;  cin = 1'b0;  #10;
        $display("a=%2d b=%2d cin=%b -> sum=%2d (%b) cout=%b", a, b, cin, sum, sum, cout);

        // 15 + 1 = 16：4 位最大值加 1，进位从 u0 一路传到 u3 走出 cout
        a = 4'd15; b = 4'd1;  cin = 1'b0;  #10;
        $display("a=%2d b=%2d cin=%b -> sum=%2d (%b) cout=%b", a, b, cin, sum, sum, cout);

        // 9 + 6 + 1 = 16：带进位输入的溢出用例
        a = 4'd9;  b = 4'd6;  cin = 1'b1;  #10;
        $display("a=%2d b=%2d cin=%b -> sum=%2d (%b) cout=%b", a, b, cin, sum, sum, cout);

        // 10 + 5 = 15：结果刚好是 4 位能表示的最大值，不溢出
        a = 4'd10; b = 4'd5;  cin = 1'b0;  #10;
        $display("a=%2d b=%2d cin=%b -> sum=%2d (%b) cout=%b", a, b, cin, sum, sum, cout);

        $finish;
    end

endmodule
