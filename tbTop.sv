
`timescale 1ns / 1ps

module tbTop #(
    parameter   p = 1)
(
);

wire clk,rstn;

clkGen clkGen0(.*);


initial
begin
    $fsdbAutoSwitchDumpfile(800, "waves.fsdb", 10);
    $fsdbDumpvars(0, tbTop,"+struct","+all");
end

`include "stim.svh"

endmodule : tbTop

