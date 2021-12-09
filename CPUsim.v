`timescale 1ns / 1ps
module CPUTB ();
    reg clkin;
	reg clkDisplay;
    reg reset;
	reg aluRes_reg3;
	reg displayHiLo;
	wire[3:0] bitSel;
	wire[6:0] segSel;

CPU u_CPU(
	//ports
	.clkin  		( clkin  		),
    .clkDisplay(clkDisplay),
	.reset  		( reset  		),
    .aluRes_reg3 (aluRes_reg3),
    .displayHiLo(displayHiLo),
    .bitSel(bitSel),
    .segSel(segSel)
);

initial begin
    reset = 1;
    clkin = 1;
    clkDisplay = 0;
    aluRes_reg3 = 0;
    displayHiLo = 0;
    #100
    reset = 0;
end

always begin
    #200
    clkin = !clkin;
end

always begin
    #100
    displayHiLo = ~displayHiLo;
end

always begin
    #1
    clkDisplay = !clkDisplay;
end

endmodule