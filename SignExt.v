`timescale 1ns / 1ps
module SignExt (
    input[15:0] inst,
    input extOp,
    output[31:0] data
);

assign data = inst[15:15] & extOp ? {16'hffff, inst}:{16'h0000, inst};
    
endmodule