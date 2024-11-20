/*
Testbench for encoder
### Author : Md. Mohiuddin Reyad (mreyad30207@gmail.com)
<br>This file is part of squared-studio:common
<br>Copyright (c) 2024 squared-studio
<br>Licensed under the MIT License
<br>See LICENSE file in the project root for full license information
*/

module encoder_tb;

  //`define ENABLE_DUMPFILE
  //`define DEBUG ;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-IMPORTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // bring in the testbench essentials functions and macros
  `include "vip/tb_ess.sv"

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-LOCALPARAMS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  localparam int NumWire = 8;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  reg  [        NumWire-1:0] d_i;
  wire [$clog2(NumWire)-1:0] addr_o;
  wire                       addr_valid_o;

  reg                        or_red;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign or_red = |d_i;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  encoder #(
      .NUM_WIRE(NumWire)
  ) encoder_dut (
      .d_i(d_i),
      .addr_o(addr_o),
      .addr_valid_o(addr_valid_o)
  );


  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-PROCEDURALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  initial begin
    int pass = 0;
    int pass_valid = 0;
    int pass_addr_o = 0;
    // check :
    // valid check: if one d_i is high then addr_valid otherwise invalid
    // do an OR operation for the d_i index value if that particular index is high ---> result will be equal to add_o then PASS otherwise FAIL
    for (int i = 0; i < 2 ** NumWire; i++) begin
      int or_ = 0;
      d_i <= $urandom;
      #5;
      foreach (d_i[i]) begin
`ifdef DEBUG
        $display("d_i index =%0d", i);
`endif  //DEBUG
        if (d_i[i]) begin
          or_ |= i;
`ifdef DEBUG
          $display("d_i[%0d]=%0d", i, d_i[i]);
`endif  //DEBUG
        end
      end
      #20;
`ifdef DEBUG  // print or_
      $display("or_=%0d", or_);
`endif  //DEBUG
      if (or_ === addr_o) begin
        pass++;
`ifdef DEBUG  //PASS print
        $display("PASS");
`endif  //DEBUG
      end
      if (or_red === addr_valid_o) begin
        pass++;
      end
`ifdef DEBUG
      $display("valid= %0d -------addr_valid_o=%0d", valid, addr_valid_o);
`endif  //DEBUG
    end
    #10;
    //$display("PASS=%0d",pass);
    if (pass == (2 * (2 ** NumWire))) begin
      pass = 1;
    end else begin
      pass = 0;
    end
    result_print(pass, "Encoder Test");

    $finish;

  end

endmodule
