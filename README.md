# verilog-zero-to-one

面向零基础的 Verilog 中文教程。从与门到触发器，每一篇都配图、配真值表推导、配可以直接跑起来的代码。

## 快速开始

环境：Windows / Linux / macOS 均可，只需 [Icarus Verilog](http://iverilog.icarus.com/)（含 `iverilog` 与 `vvp`），可选 GTKWave 看波形。

```bash
git clone https://github.com/lynn-lelelele/verilog-zero-to-one.git
cd verilog-zero-to-one/01_basics/gates

# 编译 + 仿真，应该看到四行与门真值表
iverilog -o demo.vvp assign.v or_gate_tb.v
vvp demo.vvp
```

跑通之后，按 `notes/` 的编号顺序读即可，每篇末尾都写了对应的源码位置和运行命令。

## 学习路线

| 阶段 | 内容 | 笔记 | 代码 | 状态 |
|---|---|---|---|---|
| 1 | 门电路、assign、testbench、命令行 | 01–04 | `gates/` | 已完成 |
| 2 | 位宽、取位、拼接、复制、移位 | 05–07 + 番外 | `vectors/` | 已完成 |
| 3 | 实例化、端口连接、加法器 | 08–10 | `modules/` | 已完成 |
| 4 | 组合 always、时钟、触发器、状态机 | 11–13 | `procedural/` `sequential/` | 进行中 |
| 5 | 三态、generate、参数化 | 规划中 | — | 未开始 |
| 项目 | UART、SPI、简易 CPU | 规划中 | — | 未开始 |

## 目录

```
notes/            13 篇笔记（含进制转换番外），配图在 notes/assets/
01_basics/
  gates/          7 种基本门 + 测试台
  vectors/        向量：高低位交换、复制、移位、位宽规则
  modules/        半加器、全加器、4 位行波进位加法器
  procedural/     4 选 1 选择器：case 与 if-else 两种写法
  sequential/     4 位同步复位计数器
```

## 笔记索引

| 编号 | 内容 |
|---|---|
| 01 | 7 种基本门：真值表、符号、代码 |
| 02 | `assign` 语法与常见错误 |
| 03 | testbench 三段结构，以及 reg / wire 怎么选 |
| 04 | 命令行：cd / iverilog / vvp 三条命令逐词拆解 |
| 05 | 向量：位宽、常量、取位、拼接 |
| 06 | 练习清单与验收标准 |
| 07 | 复制、移位、位宽补零与截断 |
| 08 | 模块层次：实例化、内部连线、层级树 |
| 09 | 半加器：从真值表推逻辑式 |
| 10 | 全加器：逻辑推导与结构分解两条路线 |
| 11 | `always @(*)`：case / if-else、锁存器陷阱 |
| 12 | 时钟与触发器：`posedge clk`、`<=`、复位、计数器 |
| 番外 | 进制与转换、位宽陷阱 |

## Roadmap

- [ ] 第 13 篇：有限状态机（Moore / Mealy、三段式写法）
- [ ] 第 14 篇：参数化模块与 `generate`
- [ ] 自检 testbench：从“打印给人看”升级到自动比对报错
- [ ] 项目一：UART 收发器（含波特率发生器、状态机、仿真验证）
- [ ] 项目二：RV32I 单周期 CPU 子集
- [ ] 补充 GTKWave 波形调试教程

## 参与贡献

欢迎提 Issue：笔记哪里看不懂、哪张图不清楚、哪个例子跑不通，都直接说。
也欢迎 PR：错别字、更清晰的图、补充练习与答案。新增示例请附 testbench 和实测输出。

## License

待定。
