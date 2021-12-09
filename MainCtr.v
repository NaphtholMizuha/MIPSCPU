`timescale 1ns / 1ps
module MainCtr (
    input [5:0] opcode,
    output reg regDst,
    output reg aluSrc,
    output reg memToReg,
    output reg regWrite,
    output reg memRead,
    output reg memWrite,
    output reg branch,
    output reg jmp,
    output reg jal,
    output reg extOp,
    output reg [3:0] aluOp,
    output reg lui
);

always @(opcode) begin
    case(opcode)
        // 'j'
        6'b000010: begin
            {regDst, aluSrc, memToReg, regWrite, memRead, memWrite, branch, jmp, extOp, aluOp} = 
            13'b0_0_0_0_0_0_0_1_0_0000;
        end
        // 'jal'
        6'b000011: begin
            {regDst, aluSrc, memToReg, regWrite, memRead, memWrite, branch, jmp, extOp, aluOp} = 
            13'b0_0_0_1_0_0_0_1_0_0000;
        end

        // 'R' type
        6'b000000: begin
            {regDst, aluSrc, memToReg, regWrite, memRead, memWrite, branch, jmp, extOp, aluOp} = 
            13'b1_0_0_1_0_0_0_0_1_1111;
        end

        // 'I' type
        // 'lw'
        6'b100011: begin
            {regDst, aluSrc, memToReg, regWrite, memRead, memWrite, branch, jmp, extOp, aluOp} = 
            13'b0_1_1_1_1_0_0_0_1_0000;
        end

        // 'sw'
        6'b101011: begin
            {regDst, aluSrc, memToReg, regWrite, memRead, memWrite, branch, jmp, extOp, aluOp} = 
            13'b0_1_0_0_0_1_0_0_1_0000;
        end

        // 'beq'
        6'b000100: begin
            {regDst, aluSrc, memToReg, regWrite, memRead, memWrite, branch, jmp, extOp, aluOp} = 
            13'b0_0_0_0_0_0_1_0_1_0001;
        end

        // 'bne'
        6'b000101: begin
            {regDst, aluSrc, memToReg, regWrite, memRead, memWrite, branch, jmp, extOp, aluOp} = 
            13'b0_0_0_0_0_0_1_0_1_0110;
        end

        // 'addi'
        6'b001000: begin
            {regDst, aluSrc, memToReg, regWrite, memRead, memWrite, branch, jmp, extOp, aluOp} = 
            13'b0_1_0_1_0_0_0_0_1_0000;
        end

        // 'andi'
        6'b001100: begin
            {regDst, aluSrc, memToReg, regWrite, memRead, memWrite, branch, jmp, extOp, aluOp} = 
            13'b0_1_0_1_0_0_0_0_0_0100;
        end

        // 'ori'
        6'b001101: begin
            {regDst, aluSrc, memToReg, regWrite, memRead, memWrite, branch, jmp, extOp, aluOp} = 
            13'b0_1_0_1_0_0_0_0_0_0010;
        end

        // 'xori'
        6'b001110: begin
            {regDst, aluSrc, memToReg, regWrite, memRead, memWrite, branch, jmp, extOp, aluOp} = 
            13'b0_1_0_1_0_0_0_0_0_1100;
        end

        // 'slti'
        6'b001010: begin
            {regDst, aluSrc, memToReg, regWrite, memRead, memWrite, branch, jmp, extOp, aluOp} = 
            13'b0_1_0_1_0_0_0_0_1_0011;
        end

        // 'lui'
        6'b001111: begin
            {regDst, aluSrc, memToReg, regWrite, memRead, memWrite, branch, jmp, extOp, aluOp} = 
            13'b0_1_0_1_0_0_0_0_1_1011;
        end

        6'h18: begin // 'mult'
            {regDst, aluSrc, memToReg, regWrite, memRead, memWrite, branch, jmp, extOp, aluOp} = 
            13'b0_0_0_0_0_0_0_0_1_0000;
        end

        6'h1a: begin // 'div'
            {regDst, aluSrc, memToReg, regWrite, memRead, memWrite, branch, jmp, extOp, aluOp} = 
            13'b0_0_0_0_0_0_0_0_1_0000;
        end

        6'h10: begin // 'mfhi'
            {regDst, aluSrc, memToReg, regWrite, memRead, memWrite, branch, jmp, extOp, aluOp} = 
            13'b1_0_0_1_0_0_0_0_1_0000;
        end
        
        6'h12: begin // 'mflo'
            {regDst, aluSrc, memToReg, regWrite, memRead, memWrite, branch, jmp, extOp, aluOp} = 
            13'b1_0_0_1_0_0_0_0_1_0000;
        end

        default: begin
            {regDst, aluSrc, memToReg, regWrite, memRead, memWrite, branch, jmp, extOp, aluOp} = 
            0;
        end
    endcase

    jal = (opcode == 6'b000011);
    lui = (opcode == 6'b001111);
    

end
    
endmodule