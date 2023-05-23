////////////////////////////////////////////////////////////////////////////////////////////////////
//
// ### Author : Khadija Yeasmin Fariya (fariya.khadijayeasmin@gmail.com)
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module bin_to_gray_tb;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-IMPORTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  `include "vip/tb_ess.sv"

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-LOCALPARAMS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  localparam int DataWidth = 11;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-TYPEDEFS
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [DataWidth-1:0] data_in_i;
  logic [DataWidth-1:0] data_out_o;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-INTERFACES
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-CLASSES
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  bin_to_gray #(
      .DataWidth(DataWidth)
  ) bin_to_gray_dut (
      .data_in_i (data_in_i),
      .data_out_o(data_out_o)
  );

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-METHODS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // Function
  function automatic logic [DataWidth:0] dout_bin2gray(logic [DataWidth-1:0] data_in);
    dout_bin2gray[DataWidth-1] = data_in[DataWidth-1];
    for (int i = 0; i < DataWidth - 1; i++) begin
      dout_bin2gray[i] = data_in[i] ^ data_in[i+1];
    end
  endfunction

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-PROCEDURALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  initial begin

    static int fail = 0;
    static int pass = 0;

    for (int i = 0; i < 2 ** DataWidth; i++) begin
      data_in_i <= $urandom;
      #1;
      if (data_out_o != dout_bin2gray(data_in_i)) fail++;
      else pass++;
    end

    result_print(!fail, $sformatf("data conversion %0d/%0d", pass, pass + fail));

    #100;
    $finish;
  end

endmodule
