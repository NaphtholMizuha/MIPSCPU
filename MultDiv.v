`timescale 1ns / 1ps

module MultDiv(
    input clk,
    input en,
    input mult_div,
    input[31:0] input1,
    input[31:0] input2,
    input read,
    input hi_lo,
    output[31:0] data
    );

reg [31:0] hi;
reg [31:0] lo;

initial begin
    hi = 32'b0;
    lo = 32'b0;
end

always @(negedge clk) begin
    if (en) begin
        if (mult_div) begin
            {hi, lo} = $signed(input1) * $signed(input2);
        end
        else begin
            hi = $signed(input1) % $signed(input2);
            lo = $signed(input1) / $signed(input2);
        end
    end
end

assign data = (hi_lo)? hi : lo;

endmodule
