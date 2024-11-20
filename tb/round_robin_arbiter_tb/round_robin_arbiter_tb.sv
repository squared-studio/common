// Author : Foez Ahmed (foez.official@gmail.com)
// This file is part of squared-studio:common
// Copyright (c) 2024 squared-studio
// Licensed under the MIT License
// See LICENSE file in the project root for full license information

module round_robin_arbiter_tb;

  // Parameters
  localparam int NumReq = 6;

  // Ports
  reg                       clk_i = 0;
  reg                       arst_ni = 0;
  reg                       allow_req_i = 0;
  reg  [        NumReq-1:0] req_i;
  wire [$clog2(NumReq)-1:0] gnt_addr_o;
  wire                      gnt_addr_valid_o;

  round_robin_arbiter #(
      .NUM_REQ(NumReq)
  ) round_robin_arbiter_dut (
      .clk_i(clk_i),
      .arst_ni(arst_ni),
      .allow_req_i(allow_req_i),
      .req_i(req_i),
      .gnt_addr_o(gnt_addr_o),
      .gnt_addr_valid_o(gnt_addr_valid_o)
  );

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    repeat (3) @(posedge clk_i);
    arst_ni <= 1;
    #1000;
    $finish;
  end

  always #5 clk_i = !clk_i;

  always @(posedge clk_i) begin
    allow_req_i <= ($urandom_range(0, 9) > 1);
    req_i       <= $urandom;
  end

endmodule
