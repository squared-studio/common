/*
A simple test bench for verifying the functionality of a crossbar
Author : Walid Akash (walidakash070@gmail.com)
<br>This file is part of squared-studio:common
<br>Copyright (c) 2024 squared-studio
<br>Licensed under the MIT License
<br>See LICENSE file in the project root for full license information
*/

module xbar_tb;

  //`define ENABLE_DUMPFILE

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-IMPORTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // bring in the testbench essentials functions and macros
  `include "vip/tb_ess.sv"

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-LOCALPARAMS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  localparam int ElemWidth = 4;
  localparam int NumElem = 5;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [NumElem-1:0][$clog2(NumElem)-1:0] select_i;
  logic [NumElem-1:0][      ElemWidth-1:0] inputs_i;
  logic [NumElem-1:0][      ElemWidth-1:0] outputs_o;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  xbar #(
      .ELEM_WIDTH(ElemWidth),
      .NUM_ELEM  (NumElem)
  ) xbar_dut (
      .s_i(select_i),
      .i_i(inputs_i),
      .o_o(outputs_o)
  );

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-PROCEDURALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  initial begin
    automatic int error = 0;
    repeat (100) begin

      // Generating random stimuli
      for (int i = 0; i < NumElem; i++) begin
        inputs_i[i] <= $urandom;
        select_i[i] <= $urandom;
      end
      #1;

      // Trimming select as needed
      foreach (select_i[i]) begin
        while (select_i[i] >= NumElem) begin
          select_i[i] = select_i[i] - NumElem;
        end
      end

      // Verifying results
      for (int i = 0; i < NumElem; i++) begin
        if (outputs_o[i] !== inputs_i[select_i[i]]) begin
          error++;
        end
      end
    end

    result_print(!error, "CrossBar verification");

    $finish;

  end

endmodule
