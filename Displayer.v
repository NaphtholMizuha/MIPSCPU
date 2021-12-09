`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2021 03:18:52 AM
// Design Name: 
// Module Name: Displayer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Displayer(
    input clk,
    input hi_lo,
    input[31:0] data,
    output[3:0] bitSel,
    output[6:0] segSel
    );

    reg[3:0] bitCtrl = 4'b1110;
    wire[15:0] realDisplay;

    assign realDisplay = hi_lo ? data[31:16]:data[15:0];
    
    always @(posedge clk) begin
        bitCtrl <= {bitCtrl[2:0], bitCtrl[3]};
    end

    reg[3:0] segCtrl;

    always @(bitCtrl or data) begin
        case (bitCtrl)
            4'b1110: segCtrl = realDisplay[3:0];
            4'b1101: segCtrl = realDisplay[7:4];
            4'b1011: segCtrl = realDisplay[11:8];
            4'b0111: segCtrl = realDisplay[15:12];
            default: segCtrl = 4'hf;
        endcase
    end

    reg[6:0] seg;

    always @(segCtrl) begin
        case (segCtrl)
            4'h0: seg = 7'b100_0000;//0 
            4'h1: seg = 7'b111_1001;//1 
            4'h2: seg = 7'b010_0100;//2 
            4'h3: seg = 7'b011_0000;//3 
            4'h4: seg = 7'b001_1001;//4 
            4'h5: seg = 7'b001_0010;//5 
            4'h6: seg = 7'b000_0010;//6 
            4'h7: seg = 7'b111_1000;//7 
            4'h8: seg = 7'b000_0000;//8 
            4'h9: seg = 7'b001_0000;//9 
            4'ha: seg = 7'b000_1000;//a 
            4'hb: seg = 7'b000_0011;//b 
            4'hc: seg = 7'b100_0110;//c 
            4'hd: seg = 7'b010_0001;//d 
            4'he: seg = 7'b000_0111;//e       
            4'hf: seg = 7'b000_1110;//f
            default: seg = 7'b111_1111; // no show
        endcase
    end

    assign bitSel = bitCtrl;
    assign segSel = seg;
endmodule
