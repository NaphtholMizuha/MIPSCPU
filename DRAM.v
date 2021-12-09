`timescale 1ns / 1ps
module DRAM (
    input clk,
    input reset,
    input write,
    input [31:0] adr,
    input [31:0] wd,
    output [31:0] rd
);

reg [31:0] RAM [31:0];
reg [31:0] realAdr;
//read
assign rd = RAM[adr >> 2];
//write
integer i;
always @ (posedge clk, posedge reset) begin
    if(reset) begin
        for(i = 0; i < 256; i = i + 1)
            RAM[i]=0; 
    end
    else if (write) begin 
        RAM[adr >> 2] = wd;
    end 
end
    
endmodule