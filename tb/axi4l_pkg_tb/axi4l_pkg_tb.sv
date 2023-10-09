// Description here
// ### Author : name (email)

//`include "addr_map.svh"
//`include "axi4l_assign.svh"
`include "axi4l_typedef.svh"
//`include "axi4_assign.svh"
//`include "axi4_typedef.svh"
//`include "default_param_pkg.sv"
`include "vip/axi4l_pkg.sv"
`include "vip/axi4l_pkg_macros.svh"
//`include "vip/axi4_pkg.sv"
//`include "vip/bus_dvr_mon.svh"
//`include "vip/string_ops_pkg.sv"

module axi4l_pkg_tb;

  `define ENABLE_DUMPFILE

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-IMPORTS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // bring in the testbench essentials functions and macros
  `include "vip/tb_ess.sv"

  // AXI4L VIP CLASSES IMPORT
  `IMPORT_AXI4L_PKG_CLASSES

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-LOCALPARAMS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-TYPEDEFS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  `AXI4L_T(main, 32, 64)

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // generates static task start_clk_i with tHigh:4ns tLow:6ns
  `CREATE_CLK(clk_i, 5ns, 5ns)

  logic arst_ni = 1;

  main_req_t req;
  main_resp_t resp;

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-VARIABLES{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-INTERFACES{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  `AXI4L_VIP(man, 1, clk_i, arst_ni, req, resp)
  `AXI4L_VIP(sub, 0, clk_i, arst_ni, req, resp)

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-CLASSES{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-METHODS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  task static apply_reset();  //{{{
    #100;
    arst_ni = 0;
    #100;
    arst_ni = 1;
    #100;
  endtask  //}}}

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-PROCEDURALS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  initial begin  // main initial{{{

    apply_reset();
    start_clk_i();

    sub_dvr.failure_odds = 10;

    man_dvr.start();
    sub_dvr.start();
    man_mon.start();

    repeat (25) begin
      man_seq_item_t item;
      item = new();
      item.randomize();
      item._type = 1;
      $display("%s", item.to_string());
      man_dvr_mbx.put(item);
      repeat (2) @(posedge clk_i);
      item = new item;
      item._type = 0;
      $display("%s", item.to_string());
      man_dvr_mbx.put(item);
    end

    fork
      man_mon.wait_cooldown();
      sub_mon.wait_cooldown();
    join

    while (man_mon_mbx.num()) begin
      man_resp_item_t item;
      man_mon_mbx.get(item);
      $display("%s", item.to_string());
    end

    $finish;

  end  //}}}

  //}}}

endmodule