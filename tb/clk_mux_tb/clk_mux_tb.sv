// A testbench for Clock MUX
// ### Author : Foez Ahmed (foez.official@gmail.com)

`include "vip/clocking.svh"

module clk_mux_tb;

  //`define ENABLE_DUMPFILE

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-IMPORTS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // bring in the testbench essentials functions and macros
  `include "vip/tb_ess.sv"

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // generates static task start_clk_i with tHigh:4ns tLow:6ns
  `CREATE_CLK(clk0_i, 5ns, 5ns)
  `CREATE_CLK(clk1_i, 70ns, 70ns)

  logic arst_ni = 1;
  logic sel_i = '0;
  logic clk_o;

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-VARIABLES{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  bit   en_src_0 = 0;
  bit   en_src_1 = 0;

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  clk_mux #() u_clk_mux (
      .arst_ni(arst_ni),
      .clk0_i (clk0_i),
      .clk1_i (clk1_i),
      .sel_i  (sel_i),
      .clk_o  (clk_o)
  );

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-METHODS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  task static apply_reset();  //{{{
    #100ns;
    arst_ni <= 0;
    #100ns;
    arst_ni <= 1;
    #100ns;
  endtask  //}}}

  task static rand_switch(realtime unit_time = 1ns, int unsigned min = 100,
                          int unsigned max = 10000);
    fork
      forever begin
        #(unit_time * $urandom_range(min, max));
        sel_i <= $urandom;
      end
    join_none
  endtask

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-PROCEDURALS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  initial begin
    forever begin
      fork : clk_en_block
        begin
          en_src_0 <= 0;
          en_src_1 <= 0;
          if (sel_i) begin
            @(posedge clk0_i);
            @(negedge clk0_i);
            @(posedge clk1_i);
            @(negedge clk1_i);
            en_src_1 <= 1;
          end else begin
            @(posedge clk1_i);
            @(negedge clk1_i);
            @(posedge clk0_i);
            @(negedge clk0_i);
            en_src_0 <= 1;
          end
          @(arst_ni or sel_i);
        end
        begin
          @(arst_ni or sel_i);
        end
      join_any
      disable fork;
    end
  end

  `CLOCK_GLITCH_MONITOR(clk0_i, arst_ni, 5ns, 5ns)
  `CLOCK_GLITCH_MONITOR(clk1_i, arst_ni, 5ns, 5ns)
  `CLK_MATCHING(en_src_0, clk0_i, clk_o)
  `CLK_MATCHING(en_src_1, clk1_i, clk_o)

  initial begin  // main initial{{{

    apply_reset();
    start_clk0_i();
    start_clk1_i();
    rand_switch();

    #10ms;

    // result_print(1, "This is a PASS");
    // result_print(0, "And this is a FAIL");

    $finish;

  end  //}}}

  //}}}

endmodule
