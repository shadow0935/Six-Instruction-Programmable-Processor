`timescale 1ns / 1ps

module DataMemory(D_addr, W_data, Clk, D_wr, D_rd, R_data); 

    input [7:0] D_addr; 	// Input Address 
    input [15:0] W_data; // Data that needs to be written into the address 
    input Clk;
    input D_wr; 		// Control signal for memory write 
    input D_rd; 			// Control signal for memory read 

    output reg[15:0] R_data; // Contents of memory location at Address

    
    reg [15:0] memory [0:255];
    
	always @(posedge Clk) begin
        if (D_wr) begin
            memory[D_addr] <= W_data;
        end
    end
    
    always @(*) begin
        if (D_rd)
                R_data <= memory[D_addr];
        else
                R_data <= 32'h00000000;    
    end
    
     always @(posedge Clk) begin
           $display("Memory[9] = %d", memory[9]);
       end
endmodule

module Mux16Bit3To1(out, inA, inB, inC, s1, s0);

    output reg [15:0] out;
    
    input [15:0] inA,inB,inC;
    input s0,s1;

    always @ (*) begin
        if (~s0 && ~s1)
            out <= inA;
        else if (s0 && ~s1)
            out <= inB;
        else if (~s0 && s1)
            out <= inC;
    end
endmodule

module RegisterFile(ReadRegister1, ReadRegister2, WriteRegister, WriteData, RegWrite, R1_rd, R2_rd, Clk, ReadData1, ReadData2);

    input Clk;
    input [3:0] ReadRegister1, ReadRegister2, WriteRegister;
    input RegWrite,R1_rd,R2_rd;
    input [15:0]  WriteData;
    
    output reg [15:0] ReadData1, ReadData2;
    reg [15:0] R_Addr [0:15];
     
   initial begin
        R_Addr[0] <= 16'd0;
        R_Addr[1] <= 16'd0;
        R_Addr[2] <= 16'd0;
        R_Addr[3] <= 16'd0;
        R_Addr[4] <= 16'd0;
        R_Addr[5] <= 16'd0;
        R_Addr[6] <= 16'd0;
        R_Addr[7] <= 16'd0;
        R_Addr[8] <= 16'd0;
        R_Addr[9] <= 16'd0;
        R_Addr[10] <= 16'd0;
        R_Addr[11] <= 16'd0;
        R_Addr[12] <= 16'd0;
        R_Addr[13] <= 16'd0;
        R_Addr[14] <= 16'd0;
        R_Addr[15] <= 16'd0;
   end
   
   // Write procedure
//   always @ (*)
//   begin
//       if (RegWrite)
//           R_Addr[WriteRegister] <= WriteData;
//       if (R1_rd)
//           ReadData1 <= R_Addr[ReadRegister1];
//       if (R2_rd)
//           ReadData2 <= R_Addr[ReadRegister2];
//   end

    always @ (R1_rd,R2_rd)
    begin
       if (R1_rd)
           ReadData1 <= R_Addr[ReadRegister1];
       if (R2_rd)
           ReadData2 <= R_Addr[ReadRegister2];
    end
   
    always @ (*)
      begin
          if (RegWrite)
              R_Addr[WriteRegister] <= WriteData;
      end
     always @(posedge Clk) begin
          $display("R_Addr[5] = %d", R_Addr[5]);
      end
endmodule

module checkzero(Rp_data, RF_RP_zero);
  input [15:0] Rp_data;
  output RF_RP_zero;
  assign RF_RP_zero = ~(|Rp_data); // OR of all bits followed by inversion
endmodule

// Description of half adder
module halfadder (S, C, x, y);
    input x, y;
    output S, C;
    // Instantiate primitive gates 
    xor gate1 (S, x, y);
    and gate2 (C, x, y);
endmodule

// Description of full adder
module fulladder (S, C, x, y, z);
    input x, y, z;
    output S, C;
    wire S1, D1, D2; // Outputs of first XOR and two AND gates
    // Instantiate the half adder
    halfadder HA1 (S1, D1, x, y); 
    halfadder HA2 (S, D2, S1, z);
    or gate3 (C, D2, D1);
endmodule

module bit16adder (
    output [15:0] S,
    output Cout,
    input [15:0] A, B,
    input C0
);

    wire [14:0] C; // Intermediate carries

    // Instantiate the full adder cells
    fulladder FA0 (S[0], C[0], A[0], B[0], C0);
    fulladder FA1 (S[1], C[1], A[1], B[1], C[0]);
    fulladder FA2 (S[2], C[2], A[2], B[2], C[1]);
    fulladder FA3 (S[3], C[3], A[3], B[3], C[2]);
    fulladder FA4 (S[4], C[4], A[4], B[4], C[3]);
    fulladder FA5 (S[5], C[5], A[5], B[5], C[4]);
    fulladder FA6 (S[6], C[6], A[6], B[6], C[5]);
    fulladder FA7 (S[7], C[7], A[7], B[7], C[6]);
    fulladder FA8 (S[8], C[8], A[8], B[8], C[7]);
    fulladder FA9 (S[9], C[9], A[9], B[9], C[8]);
    fulladder FA10 (S[10], C[10], A[10], B[10], C[9]);
    fulladder FA11 (S[11], C[11], A[11], B[11], C[10]);
    fulladder FA12 (S[12], C[12], A[12], B[12], C[11]);
    fulladder FA13 (S[13], C[13], A[13], B[13], C[12]);
    fulladder FA14 (S[14], C[14], A[14], B[14], C[13]);
    fulladder FA15 (S[15], Cout, A[15], B[15], C[14]);
    
endmodule

module ALU16Bit(out, inA, inB, s1, s0);
  output [15:0] out;
  input [15:0] inA, inB;
  input s1, s0;
  
  wire [15:0] adder_out;
  wire [15:0] inB_mux;
  wire Cout;
  
  // Multiplexer to select the second input of the adder
  assign inB_mux = s1 ? ~inB : inB;
  
  // Instantiate the 16-bit adder
  bit16adder adder(adder_out, Cout, inA, inB_mux, s1);
  
  // Multiplexer to select the output based on control signals
  assign out = (s1 == 1'b0 && s0 == 1'b0) ? inA : adder_out;
endmodule

module Datapath(
    input clk,
    input reset,
    output [15:0] PC,
    output [15:0] Instr,
    output [15:0] Rp_data,
    output [15:0] Rq_data,
    output [15:0] alu_out,
    output RF_RP_zero,
    output [3:0] cstate
);

    wire [15:0] PC_next, PC_addr, IR_data, W_data, D_mem_data;
    wire PC_ld, PC_clr, PC_inc, IR_ld, I_rd, D_rd, D_wr, RF_s1, RF_s0, RF_W_wr, RF_Rp_rd, RF_Rq_rd, alu_s1, alu_s0;
    wire [7:0] D_addr, RF_W_data;
    wire [3:0] RF_W_addr, RF_Rp_addr, RF_Rq_addr;

    // Program Counter
    PC pc_unit (
        .Address(PC_addr),
        .PC_ld(PC_ld),
        .PC_clr(PC_clr),
        .PC_inc(PC_inc),
        .PCResult(PC_next),
        .Clk(clk)
    );
    assign PC = PC_next;

    // Instruction Register
    IR ir_unit (
        .data(IR_data),
        .IR_ld(IR_ld),
        .Clk(clk),
        .Instr(Instr)
    );

    // PC Adder
    PCadder pc_adder_unit (
        .data(Instr[7:0]),
        .PC(PC),
        .Address(PC_addr)
    );

    // Instruction Memory
    InstructionMemory inst_mem (
        .Address(PC),
        .I_rd(I_rd),
        .Instruction(IR_data)
    );

    // Data Memory
    DataMemory data_mem (
        .D_addr(D_addr),
        .W_data(Rp_data),
        .Clk(clk),
        .D_wr(D_wr),
        .D_rd(D_rd),
        .R_data(D_mem_data)
    );
    
    //Mux to select write data
     Mux16Bit3To1 Wr_mux (
        .out(W_data),
        .inA(alu_out),
        .inB(D_mem_data),
        .inC({8'd0,RF_W_data}),
        .s1(RF_s1),
        .s0(RF_s0)
    );

    // Register File
    RegisterFile reg_file (
        .ReadRegister1(RF_Rp_addr),
        .ReadRegister2(RF_Rq_addr),
        .WriteRegister(RF_W_addr),
        .WriteData(W_data),
        .RegWrite(RF_W_wr),
        .R1_rd(RF_Rp_rd),
        .R2_rd(RF_Rq_rd),
        .Clk(clk),
        .ReadData1(Rp_data),
        .ReadData2(Rq_data)
    );

    // Check Zero
    checkzero zero_check (
        .Rp_data(Rp_data),
        .RF_RP_zero(RF_RP_zero)
    );

    // ALU
    ALU16Bit alu_unit (
        .out(alu_out),
        .inA(Rp_data),
        .inB(Rq_data),
        .s1(alu_s1),
        .s0(alu_s0)
    );
    
    // Controller instantiation
    controller control_unit (
        .clk(clk),
        .reset(reset),
        .RF_RP_zero(RF_RP_zero),
        .instr(Instr),
        .PC_ld(PC_ld),
        .PC_clr(PC_clr),
        .PC_inc(PC_inc),
        .IR_ld(IR_ld),
        .I_rd(I_rd),
        .D_addr(D_addr),
        .D_rd(D_rd),
        .D_wr(D_wr),
        .RF_W_data(RF_W_data),
        .RF_s1(RF_s1),
        .RF_s0(RF_s0),
        .RF_W_addr(RF_W_addr),
        .RF_W_wr(RF_W_wr),
        .RF_Rp_addr(RF_Rp_addr),
        .RF_Rp_rd(RF_Rp_rd),
        .RF_Rq_addr(RF_Rq_addr),
        .RF_Rq_rd(RF_Rq_rd),
        .alu_s1(alu_s1),
        .alu_s0(alu_s0),
        .state(cstate)
    );
    
endmodule
