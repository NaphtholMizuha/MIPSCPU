`timescale 1ns / 1ps
module MUX #(parameter SIZE = 32) (
    input [SIZE - 1:0] zero,
    input [SIZE - 1:0] one,
    input sel,
    output [SIZE - 1:0] res
);

assign res = sel ? one : zero;

endmodule
