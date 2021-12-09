`timescale 1ns / 1ps
module ALUCtr(
input [3:0] ALUOp, 
input [5:0] funct, 
output reg [3:0] ALUCtr,
output reg shamtSel,
output reg jr
);

always @(ALUOp or funct) begin
    
    casex({ALUOp, funct}) // 拼接操作码和功能码便于下一步的判断 
        10'b0000_xxxxxx: ALUCtr = 4'b0010; // lw，sw，addi 
        10'b0100_xxxxxx: ALUCtr = 4'b0000; // andi
        10'b0001_xxxxxx: ALUCtr = 4'b0110; // beq
        10'b1111_100000: ALUCtr = 4'b0010; // add 
        10'b1111_100010: ALUCtr = 4'b0110; // sub 
        10'b1111_000x00: ALUCtr = 4'b0011; // sll, sllv 
        10'b1111_000x11: ALUCtr = 4'b0100; // sra, srav
        10'b1111_000x10: ALUCtr = 4'b0101; // srl, srlv
        10'b1111_100100: ALUCtr = 4'b0000; // and 
        10'b1111_100101: ALUCtr = 4'b0001; // or 
        10'b1111_100110: ALUCtr = 4'b1100; // xor
        10'b1111_011000: ALUCtr = 4'b1101;  // mult
        10'b1111_011010: ALUCtr = 4'b1000;  // div
        10'b1111_010000: ALUCtr = 4'b1111;  // mfhi
        10'b1111_010010: ALUCtr = 4'b1011;  // mflo
        10'b1011_xxxxxx: ALUCtr = 4'b0011; // lui
        10'b1111_101010: ALUCtr = 4'b0111; // slt 
        10'b0010_xxxxxx: ALUCtr = 4'b0001; // ori 
        10'b0011_xxxxxx: ALUCtr = 4'b0111; // slti 
        10'b0110_xxxxxx: ALUCtr = 4'b1110; // bne 
        10'b1111_001000: ALUCtr = 4'b1001; // jr
        
        default:ALUCtr = 4'b0010;
    endcase 

    if (ALUOp == 4'b1111 && (funct == 6'b000000 || funct == 6'b000011 || funct == 6'b000010)) begin
        shamtSel = 1;
    end
    else begin
        shamtSel = 0;
    end
    
    if ({ALUOp, funct} == 10'b1111_001000) begin
        jr = 1;
    end
    else begin
        jr = 0;
    end
    

end // 如果操作码或者功能码变化执行操作 

endmodule