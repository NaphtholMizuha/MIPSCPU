`timescale 1ns / 1ps

module ALU (
    input [3:0] aluCtr,
    input [31:0] A,
    input [31:0] B,
    input [4:0] shamt,
    input shamtSel,
    input lui,
    output reg ZF, 
    output reg CF,
    output reg OF,
    output reg SF,
    output reg PF,
    output reg [31:0] F
);

reg Cout;
reg [31:0] oprand;

always @(*) begin
    Cout = 0;
    oprand = shamtSel ? shamt:A;
    case(aluCtr)
        4'b0000: begin
            // 位与
            F = A & B;
        end
        4'b0001: begin
            // 位或
            F = A | B;
        end
        4'b1100: begin
            // 位异或
            F = A ^ B;
        end
        4'b0011: begin
            if (lui) begin
                F = B << 16;
            end
            else begin
                // 算数左移
                F = B << oprand;
            end        
        end
        4'b0100: begin
            // 逻辑右移
            F = $signed(B) >>> oprand;
        end
        4'b0101: begin
            // 算数右移
            F = B >> oprand;
        end

        4'b0010: begin
            // 有溢出加法
            {Cout, F} = A + B;
        end
        4'b0110: begin
            // 有溢出减法
            {Cout, F} = A - B;
        end

        4'b1110: begin
            {Cout, F} = A - B;
            F = (F == 0);
        end

        4'b0111: begin
            // 小于比较
            F = $signed(A) < $signed(B);
        end

        default: F = 0;
    endcase

    ZF = (F == 0);
    CF = Cout;
    OF = A[31] ^ B[31] ^ F[31] ^ Cout;
    SF = F[31];
    PF = ~^F;
end



endmodule