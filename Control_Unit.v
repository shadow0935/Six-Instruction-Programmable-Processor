`timescale 1ns / 1ps

module PC(Address, PC_ld, PC_clr, PC_inc, PCResult, Clk);

	input [15:0] Address;
	input PC_ld, PC_clr, PC_inc, Clk;

	output reg [15:0] PCResult;

    // At posedge of Clk, assign output to corresponding value
    always @ (posedge Clk) begin
        if (PC_clr)
            PCResult <= 16'h0000;
        else if(PC_inc)
            PCResult <= PCResult+1;
        else if(PC_ld)
            PCResult <= Address;
    end
endmodule

module IR(data,IR_ld,Clk,Instr);
    
	input [15:0] data;
    input IR_ld,Clk;
    
    output reg [15:0] Instr;
    
    // At posedge of Clk, assign output to corresponding value
    always @ (posedge Clk) begin
        if (IR_ld)
            Instr <= data;
    end
endmodule

module PCadder(data,PC,Address);
    
	input [7:0] data;
	input [15:0] PC;   
    output [15:0] Address;
    wire [7:0] tem;
    assign tem=PC[7:0]+data-1;
    assign Address={8'd0,tem};
endmodule

module controller(
    input clk, reset, RF_RP_zero,
    input [15:0] instr,
    output reg PC_ld,
    output reg PC_clr,
    output reg PC_inc,
    output reg IR_ld,
    output reg I_rd,
    output reg [7:0] D_addr,
    output reg D_rd,
    output reg D_wr,
    output reg [7:0] RF_W_data,
    output reg RF_s1,
    output reg RF_s0,
    output reg [3:0] RF_W_addr,
    output reg RF_W_wr,
    output reg [3:0] RF_Rp_addr,
    output reg RF_Rp_rd,
    output reg [3:0] RF_Rq_addr,
    output reg RF_Rq_rd,
    output reg alu_s1,
    output reg alu_s0,
    output reg [3:0] state
);

    
//    reg [3:0] state, next_state;
    reg [3:0] next_state;
    // State Encoding
    parameter Init = 4'b0000, Fetch = 4'b0001, Decode = 4'b0010,
              Load = 4'b0011, Store = 4'b0100, Add = 4'b0101,
              Load_const = 4'b0110, Subtract = 4'b0111, Jump_if_zero = 4'b1000,
              Jump_if_zero_jmp = 4'b1001;
    
    // State Transition
    always @(posedge clk) begin
        if (reset)
            state <= Init;
        else
            state <= next_state;
    end
      
    // Next State Logic
    always @(*) begin
        case (state)
            Init: next_state = Fetch;
            Fetch: next_state = Decode;
            Decode: begin
                case (instr[15:12])
                    4'b0000: next_state = Load;
                    4'b0001: next_state = Store;
                    4'b0010: next_state = Add;
                    4'b0011: next_state = Load_const;
                    4'b0100: next_state = Subtract;
                    4'b0101: next_state = Jump_if_zero;
                    default: next_state = Fetch;
                endcase
            end
            Load: next_state = Fetch;
            Store: next_state = Fetch;
            Add: next_state = Fetch;
            Load_const: next_state = Fetch;
            Subtract: next_state = Fetch;
            Jump_if_zero: begin
                if(RF_RP_zero)
                    next_state = Jump_if_zero_jmp;
                else
                    next_state = Fetch;
            end
            Jump_if_zero_jmp: next_state = Fetch;
            default: next_state = Fetch;
        endcase
    end
      
    // Output Logic
    always @(*) begin
        PC_ld = 0;
        PC_clr = 0;
        PC_inc = 0;
        IR_ld = 0;
        I_rd = 0;
        D_addr = 0;
        D_rd = 0;
        D_wr = 0;
        RF_W_data = 0;
        RF_s1 = 0;
        RF_s0 = 0;
        RF_W_addr = 0;
        RF_W_wr = 0;
        RF_Rp_addr = 0;
        RF_Rp_rd = 0;
        RF_Rq_addr = 0;
        RF_Rq_rd = 0;
        alu_s1 = 0;
        alu_s0 = 0;
          
        case (state)
            Init: PC_clr = 1;
            Fetch: begin
                PC_inc = 1;
                IR_ld = 1;
                I_rd = 1;
            end
            Load: begin
                D_rd = 1;
                D_addr = instr[7:0];
                RF_s1 = 0;
                RF_s0 = 1;
                RF_W_addr = instr[11:8];
                RF_W_wr = 1;
            end
            Store: begin
                D_wr = 1;
                D_addr = instr[7:0];
                RF_Rp_addr = instr[11:8];
                RF_Rp_rd = 1;
            end
            Add: begin
                RF_Rp_addr = instr[7:4];
                RF_Rq_addr = instr[3:0];
                RF_W_addr = instr[11:8];
                RF_Rp_rd = 1;
                RF_Rq_rd = 1;
                alu_s1 = 0;
                alu_s0 = 1;
                RF_W_wr = 1;
            end
            Load_const: begin
                RF_s1 = 1;
                RF_W_addr = instr[11:8];
                RF_W_data = instr[7:0];
                RF_W_wr = 1;
            end
            Subtract: begin
                RF_Rp_addr = instr[7:4];
                RF_Rp_rd = 1;
                RF_Rq_addr = instr[3:0];
                RF_Rq_rd = 1;
                RF_W_addr = instr[11:8];
                RF_W_wr = 1;
                alu_s1 = 1;
            end
            Jump_if_zero: begin
                RF_Rp_addr = instr[11:8];
                RF_Rp_rd = 1;
            end
            Jump_if_zero_jmp: begin
                PC_ld = 1;
            end
        endcase
    end
  
endmodule