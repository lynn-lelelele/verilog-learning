# verilog-zero-to-one

从门电路、组合逻辑、触发器、状态机，到参数化模块、`generate` 和三态门的 Verilog 中文入门教程。每篇配图、配推导和可运行示例，代码使用 Icarus Verilog 仿真。

当前内容：**18 篇图文笔记 + 26 个 Verilog 源文件**。

本教程的 Verilog 基础主线到阶段 5 结束，不继续扩展到 UART、CPU 等完整项目。

## 快速开始

环境：Windows / Linux / macOS，只需 [Icarus Verilog](http://iverilog.icarus.com/)（含 `iverilog` 与 `vvp`），可选 GTKWave 看波形。

```bash
git clone https://github.com/lynn-lelelele/verilog-zero-to-one.git
cd verilog-zero-to-one/01_basics/gates

# 编译并仿真 7 种基本门，应该看到与门真值表
iverilog -o demo.vvp assign.v or_gate_tb.v
vvp demo.vvp
```

跑通之后，从 `notes/01-门电路.md` 开始按编号阅读。每篇末尾都写了对应源码和运行命令；命令行逐词解释见 [04-命令行](notes/04-命令行.md)。

## 学习路线

| 阶段 | 内容 | 笔记 | 代码 | 状态 |
|---|---|---|---|---|
| 1 | 门电路、`assign`、testbench、命令行 | [01–04](notes/01-门电路.md) | `gates/` | 已完成 |
| 2 | 位宽、取位、拼接、复制、移位 | [05–07 + 番外](notes/05-向量.md) | `vectors/` | 已完成 |
| 3 | 实例化、端口连接、加法器 | [08–10](notes/08-模块层次.md) | `modules/` | 已完成 |
| 4 | 组合 `always`、时钟、触发器、状态机 | [11–14](notes/11-always与组合逻辑.md) | `procedural/` `sequential/` `fsm/` | 已完成 |
| 5 | 参数化模块、`generate for`、三态门 | [15–17](notes/15-参数化模块.md) | `advanced/` | 已完成 |

> 基础主线到此结束。后续如果继续做 UART、CPU 或 FPGA 项目，属于新的学习阶段，不计入本教程未完成进度。

## 目录

```text
.
├── README.md
├── LICENSE
├── LICENSE-CC-BY-4.0.md
├── notes/                         18 篇 Markdown，配图在 notes/assets/
│   ├── 01-门电路.md
│   ├── 02-assign语法.md
│   ├── 03-testbench.md
│   ├── 04-命令行.md
│   ├── 05-向量.md
│   ├── 06-练习.md
│   ├── 07-复制与移位.md
│   ├── 08-模块层次.md
│   ├── 09-半加器.md
│   ├── 10-全加器.md
│   ├── 11-always与组合逻辑.md
│   ├── 12-时钟与触发器.md
│   ├── 13-有限状态机.md
│   ├── 14-Moore与Mealy.md
│   ├── 15-参数化模块.md
│   ├── 16-generate-for.md
│   ├── 17-三态门与inout.md
│   ├── 番外-进制转换.md
│   └── assets/                     SVG 配图与状态机交互演示
└── 01_basics/
    ├── gates/                      基本门与测试台
    ├── vectors/                    向量、复制、移位
    ├── modules/                    半加器、全加器、4 位加法器
    ├── procedural/                 case / if-else：4 选 1 选择器
    ├── sequential/                 同步/异步复位计数器
    ├── fsm/                        Moore / Mealy 1011 序列检测器
    └── advanced/                   参数化、generate、三态门
```

## 笔记索引

| 编号 | 内容 | 源码 / 图 |
|---|---|---|
| [01](notes/01-门电路.md) | 7 种基本门：真值表、符号、代码 | `01_basics/gates/` |
| [02](notes/02-assign语法.md) | `assign` 语法与常见错误 | `01_basics/gates/` |
| [03](notes/03-testbench.md) | testbench 三段结构，以及 `reg` / `wire` 怎么选 | `or_gate_tb.v` |
| [04](notes/04-命令行.md) | `cd` / `iverilog` / `vvp` 三条命令逐词拆解 | — |
| [05](notes/05-向量.md) | 位宽、常量、取位、拼接 | `01_basics/vectors/` |
| [06](notes/06-练习.md) | 练习清单与验收标准 | — |
| [07](notes/07-复制与移位.md) | 复制、移位、位宽补零与截断 | `replicate_shift.v` |
| [08](notes/08-模块层次.md) | 实例化、端口连接、内部连线 | `01_basics/modules/` |
| [09](notes/09-半加器.md) | 半加器：从真值表推逻辑式 | `half_adder.v` |
| [10](notes/10-全加器.md) | 全加器：逻辑推导与结构分解 | `full_adder.v` / `adder4.v` |
| [11](notes/11-always与组合逻辑.md) | `always @(*)`、`case` / `if-else`、锁存器陷阱 | `mux4.v` |
| [12](notes/12-时钟与触发器.md) | 时钟沿、`<=`、同步/异步复位、计数器 | `counter4.v` |
| [13](notes/13-有限状态机.md) | 状态图、三段式、1011 序列检测器 | `01_basics/fsm/` |
| [14](notes/14-Moore与Mealy.md) | Moore / Mealy、毛刺、寄存输出、互相转换 | `seq_detect1011_mealy.v` |
| [15](notes/15-参数化模块.md) | `parameter`、常量覆盖、参数化 MUX | `01_basics/advanced/` |
| [16](notes/16-generate-for.md) | `generate for`、`genvar`、参数化加法器 | `adder_param.v` |
| [17](notes/17-三态门与inout.md) | 高阻 `z`、`inout`、双向总线 | `bidir_io.v` |
| [番外](notes/番外-进制转换.md) | 进制与转换、位宽陷阱 | — |

## 学习结果

完成本教程后，能读懂并写出：

- 组合逻辑：门电路、MUX、加法器、`always @(*)`
- 时序逻辑：D触发器、同步/异步复位、计数器
- 状态机：状态图、三段式、Moore / Mealy
- 可复用结构：`parameter`、模块实例化、`generate for`
- 双向接口：`inout`、高阻 `z`、三态总线规则

## 参与贡献

欢迎提 Issue：笔记哪里看不懂、哪张图不清楚、哪个例子跑不通，都可以直接说。

也欢迎 PR：错别字、更清晰的图、补充练习与答案。新增示例请附 testbench 和实测输出。

## License

本仓库采用分许可：

- `01_basics/` 下的 Verilog 源码和 testbench 使用 [MIT License](LICENSE)。
- `notes/` 下的 Markdown 笔记、SVG/HTML 演示和图片使用 [CC BY 4.0](LICENSE-CC-BY-4.0.md)。
- 转载或改编笔记与图片时，请注明作者 `lynn-lelelele`，并链接回本仓库。

MIT 和 CC BY 4.0 都允许学习、修改、分发和商业使用；MIT 要求保留许可证声明，CC BY 要求署名。