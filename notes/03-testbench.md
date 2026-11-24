# testbench（测试台）

## 一句话定位

测试台是包在电路外面的“实验室”：**它给电路拨开关、读结果**。它不会被综合成硬件，只存在于仿真中。

## 三段结构

| 段 | 代码 | 作用 |
|---|---|---|
| 1. 声明信号 | `reg a; wire y;` | 确定哪些线由测试台控制，哪些只观察 |
| 2. 实例化 | `or_gate dut (...)` | 把被测电路放进来，接好线 |
| 3. 激励 | `initial begin ... end` | 按时间顺序拨开关、打印结果 |

## 完整例子

```verilog
module or_gate_tb;

    reg  a;
    reg  b;
    wire y;

    or_gate dut (
        .a(a),
        .b(b),
        .y(y)
    );

    initial begin
        a = 0; b = 0; #10;
        $display("a=%b b=%b y=%b", a, b, y);

        a = 0; b = 1; #10;
        $display("a=%b b=%b y=%b", a, b, y);

        a = 1; b = 0; #10;
        $display("a=%b b=%b y=%b", a, b, y);

        a = 1; b = 1; #10;
        $display("a=%b b=%b y=%b", a, b, y);

        $finish;
    end

endmodule
```

## 逐行要点

| 代码 | 人话 |
|---|---|
| `module or_gate_tb;` | 测试台没有对外引脚，括号留空 |
| `reg a; reg b;` | 测试台要主动赋值的信号，必须是 `reg` |
| `wire y;` | 测试台只观察、不赋值的信号，用 `wire` |
| `or_gate dut (...)` | 实例化被测电路，`dut` 是代号 |
| `.a(a)` | 点号左边是芯片引脚名，括号里是测试台的线名 |
| `initial` | 0 时刻开始执行一次，按顺序走 |
| `#10;` | 暂停 10 个仿真时间单位 |
| `$display(...)` | 立即打印一次，`%b` 表示二进制 |
| `$finish;` | 结束仿真，不写会一直挂着 |

## reg 与 wire 的区别

一句话：**`wire` 是导线，`reg` 是能存值的变量**。区别只在“谁能给它赋值”。

| | `wire` | `reg` |
|---|---|---|
| 本质 | 一根导线 | 一个存储单元（仿真中保存当前值） |
| 谁给它值 | `assign`、门原语、子模块输出端口 | `initial` / `always` 块里的 `=` 或 `<=` |
| 能否在过程块中赋值 | 不能 | 能 |
| 综合成什么 | 连线 | `always @(*)` 为组合逻辑；`always @(posedge clk)` 才是触发器 |
| 测试台里的角色 | 观察电路输出 | 施加激励（拨开关） |

判断口诀：

> **由别人驱动、我只观察 → `wire`；由我赋值 → `reg`。**

### 常见报错

```verilog
reg y;
assign y = a & b;        // 错：assign 只能驱动 wire
```

```verilog
wire y;
always @(*) y = a & b;   // 错：过程块赋值目标必须是 reg
```

```verilog
module m (input a, output y);
    always @(*) y = ~a;  // 错：端口默认是 wire，应写 output reg y
endmodule
```

### 容易误解的点

`reg` 不等于寄存器：

```verilog
always @(*) y = a & b;        // 组合逻辑，不会生成触发器
always @(posedge clk) q <= d; // 这才是触发器
```

是否生成触发器取决于 `always` 的敏感列表和赋值方式，不是 `reg` 这个关键字。详见阶段 4。

补充：`input` / `output` 端口默认是 `wire`，当 reg 用必须显式写 `output reg`；SystemVerilog 的 `logic` 统一了两者，但 Verilog-2001 必须区分。

## 时间轴

| 时间 | 发生什么 |
|---|---|
| 0 | 拨 a=0, b=0，然后等待 |
| 10 | 打印第 1 行，拨 a=0, b=1 |
| 20 | 打印第 2 行，拨 a=1, b=0 |
| 30 | 打印第 3 行，拨 a=1, b=1 |
| 40 | 打印第 4 行，`$finish` 结束 |

## 运行

```powershell
cd C:\Users\19918\Documents\verilog-lab\01_basics\gates
iverilog -o tb.vvp assign.v or_gate_tb.v
vvp tb.vvp
```

预期输出：

```
a=0 b=0 y=0
a=0 b=1 y=1
a=1 b=0 y=1
a=1 b=1 y=1
or_gate_tb.v:49: $finish called at 40 (1s)
```

最后一行是结束提示，不是错误。

## 常见错误

1. **把 `wire y;` 写成 `reg y;`**  
   信号变成由测试台自己驱动，被测电路的输出接不进来，`y` 读不到真实结果。

2. **改完 `.v` 不重新编译**  
   `vvp` 跑的是旧的 `.vvp` 产物，结果不会变。每次改动都要重跑 `iverilog`。

3. **先 `$display` 再赋值**  
   `reg` 初值是 `x`（未知），没赋值就打印会得到 `x`。
