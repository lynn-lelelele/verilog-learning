// 文件名   ：seq_detect_tb.v
// 内容     ：同时测试 Moore 版和 Mealy 版 1011 检测器
// 编译     ：iverilog -o fsm.vvp seq_detect1011.v seq_detect1011_mealy.v seq_detect_tb.v
// 运行     ：vvp fsm.vvp
//
// 输入流：101101101011
//   第 1..12 位 = 1 0 1 1 0 1 1 0 1 0 1 1
//   第 1 次命中：第 1..4 位  = 1011
//   第 2 次命中：第 4..7 位  = 1011（和第 1 次重叠）
//   陷阱段    ：第 7..10 位 = 1010（不是命中）
//   第 3 次命中：第 9..12 位 = 1011
//
// 这个测试台做四件事：
//   1. 产生时钟
//   2. 先复位，再逐位送入输入流
//   3. 在下降沿打印稳定快照
//   4. 在上升沿统计命中次数，最后自检
//
// 最重要的阅读规则：
//   Verilog 不是整个文件从上到下顺序执行。
//   不同的 initial / always / 模块实例从 t=0 开始并行运行，
//   写在文件前面还是后面，不代表时间上的先和后。
//   只有同一个 begin ... end 里面的语句，才按书写顺序执行。

`timescale 1ns/1ps              // 时间单位 1ns，仿真精度 1ps；所以 #5 表示 5ns

module seq_detect_tb;           // 测试台模块；没有端口，不用于综合

    reg  clk;                   // 时钟：由测试台驱动，所以声明为 reg
    reg  rst;                   // 复位：由测试台驱动，所以声明为 reg
    reg  din;                   // 串行输入：由测试台逐位改变，所以声明为 reg
    wire detected_moore;        // Moore 版输出：测试台只读取，所以声明为 wire
    wire detected_mealy;        // Mealy 版输出：测试台只读取，所以声明为 wire

    seq_detect1011 u_moore (    // 实例化 Moore 版，并给它起名 u_moore
        .clk(clk),              // 把测试台的 clk 接到 Moore 版的 clk 端口
        .rst(rst),              // 把测试台的 rst 接到 Moore 版的 rst 端口
        .din(din),              // 把测试台的 din 接到 Moore 版的 din 端口
        .detected(detected_moore) // 把 Moore 版输出接到 detected_moore 这根线
    );                          // Moore 版例化结束

    seq_detect1011_mealy u_mealy ( // 实例化 Mealy 版，并给它起名 u_mealy
        .clk(clk),              // 和 Moore 版共用同一个 clk
        .rst(rst),              // 和 Moore 版共用同一个 rst
        .din(din),              // 和 Moore 版共用同一个 din
        .detected(detected_mealy) // 把 Mealy 版输出接到 detected_mealy 这根线
    );                          // Mealy 版例化结束

    reg [11:0] stream = 12'b1011_0110_1011; // 12 位输入流；下划线只是方便人眼分组

    integer i;                  // 循环变量：从 11 数到 0，用来选 stream 的某一位
    integer hits_moore = 0;     // Moore 版命中次数；初值为 0
    integer hits_mealy = 0;     // Mealy 版命中次数；初值为 0

    initial begin               // 时钟发生器的初始块，仿真一开始就执行
        clk = 1'b0;             // 时钟先置 0，保证从一个确定电平开始
        forever #5 clk = ~clk;  // 每 5ns 翻转一次 → 周期 10ns，上升沿在 5、15、25...ns
    end                         // 时钟初始块结束

    task send_bit(input b);     // 定义“送一位”的任务；b 是这一位要送的值
        begin                   // 任务体开始
            @(posedge clk);     // 等下一个上升沿；被测模块会在这一刻采样当前 din
            #2 din = b;         // 沿后 2ns 再换下一位，避开采样瞬间的竞争
        end                     // 任务体结束
    endtask                     // send_bit 任务定义结束

    initial begin               // 主激励块：负责复位、送数据和最终自检
        rst = 1'b1;             // 一开始先拉高复位，防止状态停在未知值 x
        din = 1'b0;             // din 也给确定值，避免开头出现 x

        #12;                    // 等 12ns，跨过第一个上升沿，让复位真正生效
        rst = 1'b0;             // 放开复位，状态机从这里开始正常工作

        for (i = 11; i >= 0; i = i - 1) begin // 从最高位 stream[11] 送到最低位 stream[0]
            send_bit(stream[i]); // 把当前位送进去；task 内部会等沿并换 din
        end                     // 12 位送完，循环结束

        repeat (3) @(posedge clk); // 再等 3 个上升沿，让最后一次状态和输出稳定下来

        $display("---------------------------------------------"); // 打印分隔线
        $display("Moore 命中 %0d 次，Mealy 命中 %0d 次", // 打印两版命中次数
                 hits_moore,      // 填入 Moore 命中次数
                 hits_mealy);     // 填入 Mealy 命中次数
        if (hits_moore == 3 && hits_mealy == 3) // 自检：两个版本都必须命中 3 次
            $display("PASS：两个版本都检出 3 次 1011"); // 条件成立时打印 PASS
        else                    // 只要有一个版本不是 3 次
            $display("FAIL：期望两个版本各命中 3 次"); // 条件不成立时打印 FAIL

        $finish;                // 结束仿真，避免时钟一直跑到超时
    end                         // 主激励块结束

    always @(negedge clk) begin // 每个下降沿执行一次；此时信号已经稳定
        $display(               // 打印这一拍的状态快照
            "t=%0d ns  din=%b  state=%b  moore=%b  mealy=%b", // 输出格式：时间、输入、状态、两版输出
            $time,              // 当前仿真时间，单位 ns
            din,                // 当前这一拍等待被采样的输入位
            u_moore.state,      // 层次引用：直接读 Moore 模块内部的 state
            detected_moore,     // Moore 版当前输出
            detected_mealy      // Mealy 版当前输出
        );                      // $display 参数列表结束
    end                         // 下降沿打印块结束

    // 这个计数块虽然写在文件最后，但不是“最后才执行”。
    // 它从 t=0 起就和时钟、激励、DUT 并行运行，每个上升沿检查一次输出。
    // detected 是 DUT 产生的；这里只做观察和计数，不负责产生输出。
    // 把这一整段搬到文件顶部，仿真结果也不会改变，放这里只是为了阅读分层。
    always @(posedge clk) begin // 每个上升沿采样一次当前输出
        if (detected_moore) hits_moore = hits_moore + 1; // Moore 输出为 1 时，命中次数加 1
        if (detected_mealy) hits_mealy = hits_mealy + 1; // Mealy 输出为 1 时，命中次数加 1
    end                         // 命中计数块结束

endmodule                       // 测试台模块结束