/*
Author : Foez Ahmed (foez.official@gmail.com)
<br>This file is part of squared-studio:common
<br>Copyright (c) 2025 squared-studio
<br>Licensed under the MIT License
<br>See LICENSE file in the project root for full license information
*/

module edge_detector_tb;

  `define ENABLE_DUMPFILE

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-IMPORTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // bring in the testbench essentials functions and macros
  `include "vip/tb_ess.sv"

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // generates static task start_clk_i with tHigh:4ns tLow:6ns
  `CREATE_CLK(clk_i, 4ns, 6ns)

  logic arst_ni = 1;

  logic d_i = '0;
  logic posedge_o;
  logic negedge_o;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-VARIABLES
  //////////////////////////////////////////////////////////////////////////////////////////////////

  bit   chech_en = 0;
  bit   posedge_fail = 0;
  bit   negedge_fail = 0;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  edge_detector #(
      .POSEDGE(1),
      .NEGEDGE(1),
`ifdef ASYNC
      .ASYNC  (1)
`else
      .ASYNC  (0)
`endif
  ) u_edge_detector (
      .arst_ni(arst_ni),
      .clk_i(clk_i),
      .d_i(d_i),
      .posedge_o(posedge_o),
      .negedge_o(negedge_o)
  );

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-METHODS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  task static apply_reset();
    #100ns;
    arst_ni <= 0;
    #100ns;
    arst_ni <= 1;
    #100ns;
  endtask

  task static rand_reset(realtime unit_time = 1ns, int min = 500, int max = 5000);
    fork
      forever begin
        #(unit_time * $urandom_range(min, max));
        arst_ni <= $urandom;
      end
    join_none
  endtask

  task static rand_d(realtime unit_time = 1ns, int min = 100, int max = 1000);
    fork
      forever begin
        #(unit_time * $urandom_range(min, max));
        d_i <= $urandom;
      end
    join_none
  endtask

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-PROCEDURALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

`ifdef ASYNC
  assert property (@(posedge clk_i) disable iff (!(arst_ni & chech_en)) $rose(
      d_i
  ) |-> ##[1:2] posedge_o)
  else posedge_fail = 1;
  assert property (@(posedge clk_i) disable iff (!(arst_ni & chech_en)) $fell(
      d_i
  ) |-> ##[1:2] negedge_o)
  else negedge_fail = 1;
`else
  assert property (@(posedge clk_i) disable iff (!(arst_ni & chech_en)) $rose(
      d_i
  ) |-> ##[0:1] posedge_o)
  else posedge_fail = 1;
  assert property (@(posedge clk_i) disable iff (!(arst_ni & chech_en)) $fell(
      d_i
  ) |-> ##[0:1] negedge_o)
  else negedge_fail = 1;
`endif

  assert property (@(posedge clk_i) disable iff (!(arst_ni & chech_en)) $rose(
      posedge_o
  ) |-> ##1 $fell(
      posedge_o
  ))
  else posedge_fail = 1;

  assert property (@(posedge clk_i) disable iff (!(arst_ni & chech_en)) $rose(
      negedge_o
  ) |-> ##1 $fell(
      negedge_o
  ))
  else negedge_fail = 1;

  initial begin  // main initial

    apply_reset();
    start_clk_i();

    repeat (2) @(posedge clk_i);
    chech_en = 1;

    rand_reset();
    rand_d();

    #100us;

    result_print(!posedge_fail, "posedge detection");
    result_print(!negedge_fail, "negedge detection");

    $finish;

  end

endmodule
