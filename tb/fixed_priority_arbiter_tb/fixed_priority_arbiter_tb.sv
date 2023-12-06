// ### memory column for storing rd_data
// ### Author : Razu Ahamed (en.razu.ahamed@gmail.com)


module fixed_priority_arbiter_tb;

  //`define ENABLE_DUMPFILE

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-IMPORTS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // bring in the testbench essentials functions and macros
  `include "vip/tb_ess.sv"

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-LOCALPARAMS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  localparam int NUM_REQ = 5;

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // generates static task start_clk_i with tHigh:4ns tLow:6ns
  `CREATE_CLK(clk_i, 5ns, 5ns)
  logic                       allow_req_i;
  logic [        NUM_REQ-1:0] req_i;
  logic [$clog2(NUM_REQ)-1:0] gnt_addr_o;
  logic                       gnt_addr_valid_o;
  logic [$clog2(NUM_REQ)-1:0] ref_gnt_addr_o;  // signal for store reference output
  logic                       ref_gnt_addr_valid_o;  // signal for store reference output
  int                         pass = 0;
  int                         fail = 0;

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  fixed_priority_arbiter #(
      .NUM_REQ(NUM_REQ)
  ) u_fixed_priority_arbiter (
      .allow_req_i     (allow_req_i),
      .req_i           (req_i),
      .gnt_addr_o      (gnt_addr_o),
      .gnt_addr_valid_o(gnt_addr_valid_o)
  );

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-METHODS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  task static driver();
    fork
      forever begin
        allow_req_i <= $urandom;
        req_i       <= $urandom;
        @(posedge clk_i);
      end
    join_none
  endtask

  task automatic monitor_scoreboard();
    forever begin
      @(posedge clk_i);
      ref_model(allow_req_i, req_i, ref_gnt_addr_o, ref_gnt_addr_valid_o);

      if (ref_gnt_addr_o == gnt_addr_o && ref_gnt_addr_valid_o == gnt_addr_valid_o) begin
        pass++;
        $display(
            "Req_i=%b passed: ref_gnt_addr_o=%b, gnt_addr_o=%b,ref_gnt_addr_valid_o =%b,gnt_addr_valid_o=%b",
             req_i,ref_gnt_addr_o, gnt_addr_o, ref_gnt_addr_valid_o, gnt_addr_valid_o);
      end else begin
        fail++;
        $display(
            "Failed: ref_gnt_addr_o=%b, gnt_addr_o=%b,ref_gnt_addr_valid_o =%b,gnt_addr_valid_o=%b",
             ref_gnt_addr_o, gnt_addr_o, ref_gnt_addr_valid_o, gnt_addr_valid_o);
      end
    end
  endtask

  task automatic ref_model(input logic allow_req_i, input logic [NUM_REQ-1:0] req_i,
                           output logic [$clog2(NUM_REQ)-1:0] gnt_addr_o,
                           output logic gnt_addr_valid_o);
    gnt_addr_valid_o = allow_req_i & (|req_i);
    if (req_i == 0) begin
      gnt_addr_o = '0;
    end else begin
      for (int i = 0; i < NUM_REQ; i++) begin
        if (req_i[i] == 1) begin
          gnt_addr_o = i;
          break;
        end
        //temp++;
      end
    end
  endtask

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-PROCEDURALS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end

  initial begin
    start_clk_i();
    fork
      driver();
      monitor_scoreboard();
    join_none
    #2000;
    result_print(!fail, $sformatf("data conversion %0d/%0d", pass, pass + fail));
    $finish;
  end

  //}}}

endmodule
