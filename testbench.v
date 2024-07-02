`timescale 1ns / 1ps

module Datapath_TB;

    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in ns

    // Signals
    reg clk;
    reg reset;
    wire [15:0] PC;
    wire [15:0] Instr;
    wire [15:0] Rp_data;
    wire [15:0] Rq_data;
    wire [15:0] alu_out;
    wire RF_RP_zero;
    wire [3:0] cstate;

    // Instantiate the Datapath module
    Datapath dut (
        .clk(clk),
        .reset(reset),
        .PC(PC),
        .Instr(Instr),
        .Rp_data(Rp_data),
        .Rq_data(Rq_data),
        .alu_out(alu_out),
        .RF_RP_zero(RF_RP_zero),
        .cstate(cstate)
    );

    // Clock generation
    always #((CLK_PERIOD)/2) clk = ~clk;

    // Initial stimulus
    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        #10;
        reset = 0;
    end

endmodule
