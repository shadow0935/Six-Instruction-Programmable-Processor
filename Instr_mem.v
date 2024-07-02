`timescale 1ns / 1ps

module InstructionMemory(Address, I_rd, Instruction); 

    input [15:0] Address;        // Input Address 
    input I_rd;
    output reg [15:0] Instruction;    // Instruction at memory location Address
    
   //Create 2D array for memory with 128 32-bit elements here
        reg [31:0] memory [0:127];
        
        
        initial begin                   //need to iniitalize this for the code!
            memory[0] = 16'b0011000000011110;    //main:   lwc    $r0, 30               
            memory[1] = 16'b0011000100000001;    //        lwc    $r1, 1              
            memory[2] = 16'b0010000100010000;    //        add    $r1, $r1, $r0            
            memory[3] = 16'b0010010000000001;    //        add    $r4, $r0, $r1         
            memory[4] = 16'b0100001100000001;    //        sub    $r3, $r0, $r1              
            memory[5] = 16'b0100010000110001;    //        sub    $r4, $r3, $r1             
            memory[6] = 16'b0001000000001001;    //        sw     $r0, $d9               
            memory[7] = 16'b0000010100001001;    //        lw     $r5, $d9              
            memory[8] = 16'b0011011000000000;    //        lwc    $r6, 0                 
            memory[9] = 16'b0101011000000010;    //        jz     $r6, 4              
            memory[11] = 16'b0011011000000000;   //        lwc    $r6, 0                 
            memory[12] = 16'b0101011011111100;   //        jz     $r6, -4        
            
//            memory[0] = 16'b0011000000011110;    //main:   lwc    $r0, 30              
//            memory[1] = 16'b0011000100000001;    //        lwc    $r1, 1              
//            memory[2] = 16'b0010001000000000;    //        add    $r2, 0            
//            memory[3] = 16'b0010001000100001;    //        add    $r2, $r2, $r1         
//            memory[4] = 16'b0100000000000001;    //        sub    $r0, $r0, $r1              
//            memory[5] = 16'b0101000011111110;    //        jz     $r0, 2        
//            memory[6] = 16'b0101000011111101;    //        jz     $r0, -3
//            memory[7] = 16'b0001000000001001;    //        sw     $r0, $d9               
//            memory[8] = 16'b0001001000001010;    //        sw     $r2, $d10  
        end
        
        always @(*) begin
           if(I_rd)
            Instruction <= memory[Address[15:0]];    
        end
        
    endmodule
