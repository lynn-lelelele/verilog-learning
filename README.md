# verilog-lab

从零开始学 Verilog 的练习仓库。按“语法 → 小电路 → 大项目”推进。

## 目录结构

```
verilog-lab/
├── README.md            ← 本文件，索引与进度
├── notes/               ← 学习笔记
│   ├── 01-门电路.md
│   ├── 02-assign语法.md
│   ├── 03-testbench.md
│   ├── 04-命令行.md
│   ├── 05-向量.md
│   ├── 06-练习.md
│   ├── 07-复制与移位.md
│   └── assets/          ← 笔记里的电路图
└── 01_basics/           ← 阶段 1-2 代码
    ├── gates/           ← 基本门与测试台
    │   ├── assign.v
    │   └── or_gate_tb.v
    └── vectors/         ← 向量
        ├── nibble_swap.v
        ├── nibble_swap_tb.v
        ├── replicate_shift.v
        └── replicate_shift_tb.v
```

## 笔记索引

| 编号 | 内容 |
|---|---|
| 01 | 7 种基本门：真值表、符号、代码 |
| 02 | `assign` 语法与常见错误 |
| 03 | testbench 结构与运行 |
| 04 | 命令行：cd / iverilog / vvp |
| 05 | 向量：位宽、常量、取位、拼接（配图） |
| 06 | 练习清单与验收标准 |
| 07 | 复制、移位、位宽规则（配图） |

## 运行方式

```powershell
cd C:\Users\19918\Documents\verilog-lab\01_basics\gates
iverilog -o tb.vvp assign.v or_gate_tb.v
vvp tb.vvp
```

```powershell
cd C:\Users\19918\Documents\verilog-lab\01_basics\vectors
iverilog -o swap.vvp nibble_swap.v nibble_swap_tb.v
vvp swap.vvp
```

## 环境

- Icarus Verilog 12.0（`C:\iverilog\bin`，已加入 PATH）
- GTKWave（`C:\iverilog\gtkwave\bin`）
- VS Code + 扩展 `mshr-h.veriloghdl`

## 进度

| 阶段 | 内容 | 状态 |
|---|---|---|
| 1 | 门与 assign、基本 testbench | 进行中 |
| 2 | 向量：位宽、位选、拼接、移位 | 未开始 |
| 3 | 模块层次：实例化、端口连接 | 未开始 |
| 4 | 时序与过程块：always、if/case、寄存器 | 未开始 |
| 5 | 更多特性：三态、generate、参数化 | 未开始 |
