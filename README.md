Xilinx JTAG Toolchain on Digilent Arty board
===

This is a small experimental project to validate the functionality of Xilinx FPGA Configuration JTAG  `USER4` register, which applied by Xilinx `BSCANE2` [1] module in Verilog source code.

With Xilinx `BSCANE2` module, it's much easiler to transfer binary data between PC and FPGA via Xilinx official JTAG cable. For example, when build digital laboratory environment on Digilent Arty board, use `USB-JTAG` for configuring FPGA bitstream and transfer test data to FPGA module, save the `USB-UART` to receive readable string from FPGA module in terminal application on PC.

Currently, `BSCANE2` module has been parameterized as 32-bit register for JTAG DR-SHIFT state, as `JDATA_WIDTH` parameter in `jtag_test` module. But it's not only support byte (8-bit) aligend register operation, as [learn-rv32i-arty project](https://github.com/watz0n/learn-rv32i-arty), which interfacing JTAG `USER4` register by 41-bit width for RISC-V Debug Module Interface (DMI) data-structure.

I assume the reader for this project are familiar with Xilinx Vivado project mode, which based on [Xilinx Vivado 2017.4](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/2017-4.html) WebPack edition, and FPGA applied on [Digilent Arty board](https://store.digilentinc.com/arty-a7-artix-7-fpga-development-board-for-makers-and-hobbyists/).

Adhere, this README focus on how to use Xilinx Software Command-line Tools (XSCT) to perform Xilinx JTAG `USER4` register read/write operations. If you want to know the development walkthrough, please reference the blog post: [Xilinx JTAG Toolchain 101] (TBD).

Usage Guide
===

Prepare FPGA Hardware
---
1. Clone project respository
```
git clone https://github.com/watz0n/arty_xjtag.git
```
2. Open `arty_jtag.xpr` by Xilinx Vivado 2017.4 in Project Mode
3. Push `Generate bitstream`, then select `Yes` in `No Implementation Results Availble` dialog
4. Attach PC and Arty by USB cable
5. Select `Open Hardware Manager` in `Bitstream Generation Complete`, then push `Yes`
6. Select `Open Target`, `Auto Connect`
7. Push `Program Device`, use `Bitstream File` right most `...` button to select file `arty_jtag.runs/impl_1/jtag_test.bit`, then push `Program` button
8. Push `>>` (immediately sampling data) button in `hw_ila_1`, `jtag_data` should be `00000000`(hex)

Xilinx Software Command-line Tools for JTAG Sequence
---
1. Open `Xilinx Software Command Line 2017.4` under `Xilinx Design Tools`
2. Load `jtag_reorder.tcl`, for example, the project directory is `d:\project\arty_xjtag`
```
# Notice the path layer difference between Windows(\) and Linux(/)
# XSCT use Linux(/) form
xsct$ source d:/project/arty_xjtag/tcl/jtag_reorder.tcl
```
3. Setup Xilinx JTAG sequence as `jseq` object
```
xsct% connect
xsct% jtag targets
  1  Digilent Arty 210319755023A
     2  xc7a35t (idcode 0362d093 irlen 6 fpga)
        3  bscan-switch (idcode 04900101 irlen 1 fpga)
           4  unknown (idcode 04900220 irlen 1 fpga)
xsct% jtag targets 2
xsct% set jseq [jtag sequence]
```
4. Send data by JTAG sequence in XSCT [3]
```
# Select JTAG Register USER4 [2]
xsct% $jseq irshift -state IDLE -hex 6 23
xsct% $jseq drshift -state IDLE -hex 32 [jtag_reorder 12345678]
xsct% $jseq run
xsct% $jseq clear
```
5. Back to Vivado Hardware Manager `hw_ila_1`, push `>>`, `jtag_data` should be `12345678`
6. Read data by JTAG sequence in XSCT [3]
```
# Select JTAG Register USER4 [2]
xsct% $jseq irshift -state IDLE -hex 6 23
xsct% $jseq drshift -state IDLE -tdi 0 -capture 32
xsct% set result [jtag_reorder [$jseq run]]
12345678
xsct% $jseq clear
xsct% puts $result
12345678
```

Read Arty FPGA IDCODE by XSCT
---
After previous step 3, setup JTAG sequence as `jseq`
```
# Select JTAG Register IDCODE [2]
xsct% $jseq irshift -state IDLE -hex 6 09
xsct% $jseq drshift -state IDLE -tdi 0 -capture 32
xsct% set result [jtag_reorder [$jseq run]]
0362d093
xsct% $jseq clear
xsct% puts $result
0362d093
```
Result as reference [2], `Artix 7A35T X362D093`

Reference
===

1. [Xilinx UG429 : 7Series FPGAs Migration Methodology Guide](https://www.xilinx.com/support/documentation/sw_manuals/ug429_7Series_Migration.pdf)
```
BSCAN_VIRTEX6 -> BSCANE2
JTAG_SIM_VIRTEX6 -> JTAG_SIME2
SIM_CONFIG_V6 -> SIM_CONFIGE2
```

2. [Xilinx UG470 : FPGA Configuration Guide](https://www.xilinx.com/support/documentation/user_guides/ug470_7Series_Config.pdf)

3. [Xilinx UG1208 : XSCT Reference Guide](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2017_4/ug1208-xsct-reference-guide.pdf)


Support Project
===

* [learn-rv32i-arty project](https://github.com/watz0n/learn-rv32i-arty), port unpipelined RV32I simulation core [learn-rv32i-asap](https://github.com/watz0n/learn-rv32i-asap) in [Digilent Arty board](https://store.digilentinc.com/arty-a7-artix-7-fpga-development-board-for-makers-and-hobbyists/) Artix 7A35T FPGA.

Contact Information
===

If you have any questions, corrections, or feedbacks, please email to me or open an issus.

* E-Mail:   watz0n.tw@gmail.com
* Blog:     https://blog.watz0n.tech
* Backup:   https://watz0n.github.io

