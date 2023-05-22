////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    Author : Name (email)
//
////////////////////////////////////////////////////////////////////////////////////////////////////

//`include "axi4/typedef.svh"
//`include "axi4l/typedef.svh"
//`include "vip/bus_dvr_mon.svh"

//`include "vip/string_ops_pkg.sv"

module tb_model;

  //`define ENABLE_DUMPFILE

  // bring in the testbench essentials functions and macros
  `include "vip/tb_ess.sv"

  // generates static task start_clk_i with tHigh:3 tLow:7
  `CREATE_CLK(clk_i, 3, 7)

  bit arst_ni = 1;

  task static apply_reset();
    #100;
    arst_ni = 0;
    #100;
    arst_ni = 1;
    #100;
  endtask

  initial begin
    apply_reset();
    start_clk_i();

    @(posedge clk_i);
    result_print(1, "This is a PASS");
    @(posedge clk_i);
    result_print(0, "And this is a FAIL");

    $finish;

  end

endmodule
