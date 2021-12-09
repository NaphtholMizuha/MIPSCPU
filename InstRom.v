module InstRom (
    input [31:0] pc,
    output reg [31:0] inst
);

reg [31:0] instSet[255:0];
integer realAdd, i;

initial begin
    for (i = 0; i < 256; i = i + 1) begin
        instSet[i] = 0;
    end

    $readmemh("/home/kali/Documents/vivado/CPU1/CPU1.srcs/sources_1/new/hello.txt", instSet);

end

always @(pc) begin
    realAdd = pc >> 2;
    inst = instSet[realAdd];
end
    
endmodule