`timescale 1ns / 1ps
module PCNext(
    input                           clk,
    input                           reset,
    input jmp,
    input jr,
    input[31:0] jrAdr,
    input branch,
    input[31:0] expand,
    input[31:0] inst,
    input zero,
    output reg [31:0] pc
);

wire pcSrc1, pcSrc2;
wire[31:0] jAdr, branchAdr;
wire[31:0] pcAdd4;
integer start;

assign pcAdd4 = pc + 4;
assign branchAdr = pcAdd4 + (expand << 2);
assign jAdr = jr ? jrAdr:{pcAdd4[31:28], inst[25:0], 2'b00};

assign pcSrc1 = (branch & zero);
assign pcSrc2 = (jmp | jr);

initial begin
    pc = 0;
    start = 0;
end

always @(posedge clk) begin

    if (start) begin
        
        casex({pcSrc2, pcSrc1})
            2'b00: pc <= pc + 4;
            2'b01: pc <= branchAdr;
            2'b1x: pc <= jAdr;
            default: pc <= pc + 4;
        endcase

        if (reset) pc = 0;
    end
    else start = ~start;

end


endmodule  //module_name