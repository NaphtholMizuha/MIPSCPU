`timescale 1ns / 1ps
module CPU (
    input clkin,
	input clkDisplay,
    input reset,
	input aluRes_reg3,
	input displayHiLo,
	output[3:0] bitSel,
	output[6:0] segSel
);

wire[31:0] memReadData;
wire       	branch;
wire       	jmp;
wire       	jal;
wire lui;
wire mult_div;
wire multDivEn;
wire mf;
wire mfhilo;
wire [31:0]inst;


wire regDst, regWrite, memRead, memWrite, memToReg, aluSrc, extOp;
wire[3:0] aluOp;
wire ZF, OF, CF, PF, SF;

wire[3:0] aluCtr;
wire[31:0] inputA, inputB;
wire[15:0] data;
wire[31:0] aluRes;
wire[31:0] multDivRes;
wire[31:0] pc;

wire[31:0] rsData, rtData, expand;
wire[4:0] regWriteAdr;
wire[31:0] regWriteData;

// for display
wire[31:0] displayData;
wire[31:0] reg3;

assign displayData = aluRes_reg3 ? aluRes:reg3;

assign regWriteAdr = jal ? 5'h1f : (regDst ? inst[15:11] : inst[20:16]);

assign data = aluRes[15:0];
assign regWriteData = jal ? (pc + 4) : (mf ? multDivRes : (memToReg ? memReadData : aluRes));

assign inputA = rsData;
assign inputB = aluSrc ? expand : rtData;

assign multDivEn = (aluCtr == 4'b1101 || aluCtr == 4'b1000);
assign mult_div = (aluCtr == 4'b1101);
assign mf = (aluCtr == 4'b1111 || aluCtr == 4'b1011);
assign mfhilo = (aluCtr == 4'b1111);
 
InstRom im(.pc(pc), .inst(inst));

MainCtr u_MainCtr(
	//ports
	.opcode   		( inst[31:26]   		),
	.regDst   		( regDst   		),
	.aluSrc   		( aluSrc   		),
	.memToReg 		( memToReg 		),
	.regWrite 		( regWrite 		),
	.memRead  		( memRead  		),
	.memWrite 		( memWrite 		),
	.branch   		( branch   		),
	.jmp      		( jmp      		),
	.jal      		( jal      		),
	.extOp    		( extOp    		),
	.aluOp    		( aluOp    		),
	.lui			(lui)

);

wire       	shamtSel;
wire		jr;
ALUCtr u_ALUCtr(
	//ports
	.ALUOp    		( aluOp    		),
	.funct    		( inst[5:0]    		),
	.ALUCtr   		( aluCtr   		),
	.shamtSel 		( shamtSel 		),
	.jr				(jr)
);


RegFile u_RegFile(
	//ports
	.Clk       		( !clkin       		),
	.Clr       		( reset       		),
	.Write_Reg 		( regWrite		),
	.R_Addr_A  		( inst[25:21]  		),
	.R_Addr_B  		( inst[20:16]  		),
	.W_Addr    		( regWriteAdr    		),
	.W_Data    		( regWriteData    		),
	.R_Data_A  		( rsData  		),
	.R_Data_B  		( rtData  		),
	.reg3(reg3)
);

ALU u_ALU(
	//ports
	.aluCtr   		( aluCtr   		),
	.A        		( inputA        		),
	.B        		( inputB       		),
	.shamt    		( inst[10:6]    		),
	.shamtSel 		( shamtSel 		),
	.lui			(lui),
	.ZF       		( ZF       		),
	.CF       		( CF       		),
	.OF       		( OF       		),
	.SF       		( SF       		),
	.PF       		( PF       		),
	.F        		( aluRes        		)
);

SignExt u_SignExt(
	//ports
	.inst  		( inst[15:0]  		),
	.extOp 		( extOp 		),
	.data  		( expand  		)
);

DRAM u_DRAM(
	//ports
	.clk   		( clkin   		),
	.reset 		( reset 		),
	.write 		( memWrite 		),
	.adr   		( aluRes   		),
	.wd    		( rtData    		),
	.rd    		( memReadData    		)
);

PCNext u_PCNext(
	//ports
	.clk   		( clkin   		),
	.reset 		( reset 		),
	.pc    		( pc    		),
	.expand (expand),
	.jr(jr),
	.branch(branch),
	.jmp(jmp),
	.inst(inst),
	.jrAdr(rsData),
	.zero(ZF)
);

MultDiv u_MultDiv(
	.mult_div(mult_div),
	.input1(inputA),
	.input2(inputB),
	.en(multDivEn),
	.read(mf),
	.hi_lo(mfhilo),
	.data(multDivRes),
	.clk(clkin)
);


Displayer u_Displayer(
	.clk(clkDisplay),
	.hi_lo(displayHiLo),
	.data(displayData),
	.bitSel(bitSel),
	.segSel(segSel)
);

    
endmodule

