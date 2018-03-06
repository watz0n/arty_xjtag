`timescale 1ns / 1ps

/* //
//      Xilinx Official JTAG Interface Tester Testbench
//      Author: Watson Huang
//      Module Description:
//          Test JTAG_SIME2 funtion to simulate JTAG behavior in Vivado SImulator.
//          But Xilinx UG768/UG953 didn't describe this simulation module, only Xilinx UG492 announce it's preceding module is JTAG_SIM_VIRTEX6
//          Change instantiation format from  JTAG_SIM_VIRTEX6 form Xilinx UG623 
 //     Change Log:
 //     01/25, 2018: Simulation done
 //     01/27, 2018: Gated Clock for JTAG TCK
 //     02/18, 2018: Change jtag_data which would be parameterized by JDATA_WIDTH
*/ //

module jtag_sim(
);

parameter JDATA_WIDTH = 32;

localparam JCLK_MFREQ = 100;
reg jclk; initial begin jclk = 0; end always begin jclk = #((1000/JCLK_MFREQ)/2) ~jclk; end

localparam BDCLK_MFREQ = 100;
reg bdclk; initial begin bdclk = 0; end always begin bdclk = #((1000/BDCLK_MFREQ)/2) ~bdclk; end

reg [JDATA_WIDTH-1:0] tx_data = {JDATA_WIDTH{1'b0}};

wire tdo;
wire tck;
reg tdi;
reg tms;
reg tck_en;

assign tck = tck_en & jclk;

initial begin: init_env
    tck_en = 0;
    tdi = 0;
    tms = 0;
end

JTAG_SIME2 #(
    .PART_NAME("7A35T")
) jtag_sim_arty_inst (
    .TDO(tdo), // 1-bit JTAG data output
    .TCK(tck), // 1-bit Clock input
    .TDI(tdi), // 1-bit JTAG data input
    .TMS(tms) // 1-bit JTAG command input
);

//Use JTAG_SIME2 to control JTAG_
jtag_test#(
    .JDATA_WIDTH(JDATA_WIDTH)
)
jtag_arty_inst(
    .board_clock(bdclk)
);

initial begin: sim_main
    
    repeat(1) @(negedge jclk);
    
    tck_en = 1;
    repeat(1) @(negedge jclk);
    
    tms = 1; //goto TLR
    repeat(25) @(negedge jclk);  
    tck_en = 0;
    repeat(2) @(negedge jclk);
    
    //at TLR
    tms = 0; tck_en = 1;
    repeat(1) @(negedge jclk);  

    //at RTI
    
    tms = 1; tck_en = 1;
    repeat(1) @(negedge jclk); 
    tms = 1; tck_en = 1;
    repeat(1) @(negedge jclk); 
    
    //at  SELECT-IR-SCAN
    
    tms = 0; tck_en = 1;
    repeat(1) @(negedge jclk);
    
    //at CAPTURE-IR 
    tms = 0; tck_en = 1;
    tdi = 0;
    repeat(1) @(negedge jclk); 
    
    //at  SHIFT-IR
    tms = 0; tck_en = 1;
    tdi = 1;
    repeat(1) @(negedge jclk);
    tms = 0; tck_en = 1;
    tdi = 1;
    repeat(1) @(negedge jclk); 
    tms = 0; tck_en = 1;
    tdi = 0;
    repeat(1) @(negedge jclk);
    tms = 0; tck_en = 1;
    tdi = 0;
    repeat(1) @(negedge jclk);
    tms = 0; tck_en = 1;
    tdi = 0;
    repeat(1) @(negedge jclk); 
    tms = 1; tck_en = 1; //LAST IR Bit
    tdi = 1;
    repeat(1) @(negedge jclk); 
    
    // Send (LSB) 110001 (MSB), for Xilinx JTAG IR CODE  USER4: (MSB) 100011 (LSB)
    // Because ILA core use USER1 as default control port
    
    //And enter EXIT-IR
    tms = 1; tck_en = 1;
    repeat(1) @(negedge jclk);  
    tms = 0; tck_en = 1;
    repeat(1) @(negedge jclk); 


    //at RTI
    
    tms = 1; tck_en = 1;
    repeat(1) @(negedge jclk); 
    //tms = 1; tck_en = 1;
    //repeat(1) @(negedge jclk); 
    
    //at  SELECT-DR-SCAN
    
    tms = 0; tck_en = 1;
    repeat(1) @(negedge jclk);  
    tms = 0; tck_en = 1;
    repeat(1) @(negedge jclk); 
    
    //at SHIFT-DR
    tms = 0; tck_en = 1;
    tdi = 0;
    repeat(31) @(negedge jclk);
    
    tx_data = 'hFF55AA00;
    repeat(JDATA_WIDTH-1) begin
        tms = 0; tck_en = 1;
        tdi = tx_data[0];
        tx_data = {1'b0, tx_data[JDATA_WIDTH-1:1]};
        @(negedge jclk);
    end
    
    //goto EXIT-DR
    tms = 1; tck_en = 1;
    tdi = tx_data[0];
    tx_data = {1'b0, tx_data[JDATA_WIDTH-1:1]};
    repeat(1) @(negedge jclk);
    
    //at EXIT-DR, goto RTI
    tms = 1; tck_en = 1;
    repeat(1) @(negedge jclk);  
    tms = 0; tck_en = 1;
    repeat(1) @(negedge jclk); 
    
    $display("jtag_data: %x", jtag_arty_inst.jtag_data); 
    
    tms = 0; tck_en = 0;
    repeat(5) @(negedge jclk);
    
    $finish;
end

endmodule
