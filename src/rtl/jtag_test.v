`timescale 1ns / 1ps

/* //
//      Xilinx Official JTAG Interface Test Module
//      Author: Watson Huang
//      Module Description:
//          Test BSCANE2 function through Xilinx JTAG Toolchain (XSDB)
//      Change Log:
//      01/25, 2018: Function test done
//      02/18, 2018: Change jtag_data which would be parameterized by JDATA_WIDTH
*/ //

module jtag_test#(
    //parameter JDATA_WIDTH = 32 //Byte Shift Test
    parameter JDATA_WIDTH = 35 //Bit Shift Test
)(
    output [3:0] led,
    input board_clock
);

(* KEEP = "TRUE" *) reg [JDATA_WIDTH-1:0] jtag_data;

wire shift;
wire sel;

wire tck;
wire tdi;
wire tdo;
wire tms;

wire data_valid;

wire capture;
wire update;

wire debug_clock;
wire pll_locked;

assign tdo = jtag_data[0];
assign data_valid = shift&sel;

initial begin
    jtag_data[JDATA_WIDTH-1:0] = {JDATA_WIDTH{1'b0}};
end

always@(posedge tck) begin
    if(data_valid) begin
        jtag_data[JDATA_WIDTH-1:0] <= {tdi, jtag_data[JDATA_WIDTH-1:1]};
    end
end

BSCANE2 #(
    .JTAG_CHAIN(4) // Value for USER command.
)
bse2_inst (
    .CAPTURE(capture), // 1-bit output: CAPTURE output from TAP controller.
    .DRCK(), // 1-bit output: Gated TCK output. When SEL is asserted, DRCK toggles when CAPTURE or SHIFT are asserted.
    .RESET(), // 1-bit output: Reset output for TAP controller.
    .RUNTEST(), // 1-bit output: Output asserted when TAP controller is in Run Test/Idle state.
    .SEL(sel), // 1-bit output: USER instruction active output.
    .SHIFT(shift), // 1-bit output: SHIFT output from TAP controller.
    .TCK(tck), // 1-bit output: Test Clock output. Fabric connection to TAP Clock pin.
    .TDI(tdi), // 1-bit output: Test Data Input (TDI) output from TAP controller.
    .TMS(tms), // 1-bit output: Test Mode Select output. Fabric connection to TAP.
    .UPDATE(update), // 1-bit output: UPDATE output from TAP controller
    .TDO(tdo) // 1-bit input: Test Data Output (TDO) input for USER function.
);

board_pll board_pll (
    // Clock out ports
    .clk_out1(debug_clock),     // output clk_out1
    // Status and control signals
    .reset(1'b0), // input reset
    .locked(pll_locked),       // output locked
    // Clock in ports
    .clk_in1(board_clock) // input clk_in1
);      

assign led[0] = 1'b0;
assign led[1] = 1'b0;
assign led[2] = sel;
assign led[3] = pll_locked;

endmodule
