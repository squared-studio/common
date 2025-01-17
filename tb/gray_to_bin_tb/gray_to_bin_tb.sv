/*
Simple testbench for Gray to Binary code converter
Author : Razu Ahamed (engr.razu.ahamed@gmail.com)
<br>This file is part of squared-studio:common
<br>Copyright (c) 2025 squared-studio
<br>Licensed under the MIT License
<br>See LICENSE file in the project root for full license information
*/

module gray_to_bin_tb;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-IMPORTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // Include tb_ess.sv file
  `include "vip/tb_ess.sv"

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-LOCALPARAMS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // Declare a local parameter that defines the depth of input and output data
  localparam int DataWidth = 11;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // Decleare two singals for input and output
  logic [DataWidth-1:0] data_in_i;
  logic [DataWidth-1:0] data_out_o;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // Instantiate the DUT
  gray_to_bin #(
      .DATA_WIDTH(DataWidth)
  ) gray_to_bin_dut (
      .data_in_i (data_in_i),
      .data_out_o(data_out_o)
  );

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-METHODS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // Make reference model
  function automatic logic [DataWidth-1:0] data_out_gray_to_bin(logic [DataWidth-1:0] data_in);
    data_out_gray_to_bin[DataWidth-1] = data_in[DataWidth-1];
    for (int i = DataWidth - 2; i >= 0; i--) begin
      data_out_gray_to_bin[i] = data_out_gray_to_bin[i+1] ^ data_in[i];
    end
  endfunction

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-PROCEDURALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  initial begin
    static int fail = 0;  // Deleare a signal for counting how many time data are matching
    static int pass = 0;  // Declare a signal for counting how many time data are mismatching

    for (int i = 0; i < 2 ** DataWidth; i++) begin
      data_in_i <= $urandom;  //Randomizing the input data
      #1;                     // added 1 time unit delay
      // Calling the function and compare actual data with expected data
      if (data_out_o !== data_out_gray_to_bin(data_in_i)) fail++;
      else pass++;
    end
    // Display passed and failed ratio
    result_print(!fail, $sformatf("data conversion %0d/%0d", pass, pass + fail));
    $finish;  // Terminate the simulation
  end

endmodule
