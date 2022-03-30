/*
  Copyright 2022 by Trex project. All Rights Reserved.

  File name:        tbTop
  Author:           
  Initial Version:  Tue Mar 29 16:55:05 2022
  Release Version:

  $Id: tbTop.sv,v 1.1 2022/03/30 04:01:37 yc_yang Exp $
*/
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

