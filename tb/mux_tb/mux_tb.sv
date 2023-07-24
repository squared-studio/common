// Testbench for mux
// ### Author : Md. Mohiuddin Reyad (mreyad30207@gmail.com)

module mux_tb #(
    parameter int ELEM_WIDTH = 8,
    parameter int NUM_ELEM   = 6,
    parameter int RUN_TEST   = 10     // number of test to run/repeat
  );

`define ENABLE_DUMPFILE
//`define DEBUG   //comment this to turn off mux elements display
`define RANDOM_TEST   //comment this to run generated sequence test

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-IMPORTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // bring in the testbench essentials functions and macros
`include "vip/tb_ess.sv"

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [$clog2(NUM_ELEM)-1:0]                 sel_i;
  logic [        NUM_ELEM-1:0][ELEM_WIDTH-1:0] inputs_i;
  logic [      ELEM_WIDTH-1:0]                 output_o;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-VARIABLES
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////
  mux #(
        .ELEM_WIDTH(ELEM_WIDTH),
        .NUM_ELEM  (NUM_ELEM)
      ) mux_dut (
        .sel_i   (sel_i   ),
        .inputs_i(inputs_i),
        .output_o(output_o)
      );

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-METHODS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // randomly input data for mux will be generated
  task static random_input(output int pass, output int fail);
    for (int i = 0; i < NUM_ELEM; i++)
    begin
      inputs_i[i] = $urandom_range(0, 2 ** ELEM_WIDTH);
`ifdef DEBUG

      $display("inputs_i[%0d] =%0d", i, inputs_i[i]);
`endif  //DEBUG

    end

    foreach (inputs_i[i])
    begin
      sel_i = $urandom_range(0, (NUM_ELEM-1));
      #2;
`ifdef DEBUG

      $display("sel_i = %0d,output_o = %0d", sel_i, output_o);
`endif  //DEBUG

      if (inputs_i[sel_i] != output_o)
        fail++;
      else
        pass++;
    end

  endtask

  // input data is generated sequentially
  task static generated_input(output int pass, output int fail);
    for (int i = 0; i < NUM_ELEM; i++)
    begin
      inputs_i[i] = i + NUM_ELEM;
`ifdef DEBUG

      $display("inputs_i[%0d] =%0d", i, inputs_i[i]);
`endif  //DEBUG

    end
    foreach (inputs_i[i])
    begin
      sel_i = $urandom_range(0, NUM_ELEM);
      #2;
`ifdef DEBUG

      $display("sel_i = %0d,output_o = %0d", sel_i, output_o);
`endif  //DEBUG

      if (inputs_i[sel_i] != output_o)
        fail++;
      else
        pass++;
    end
  endtask

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-PROCEDURALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  initial
  begin
    int pass;
    int fail;

    // random_input task call
    `ifdef RANDOM_TEST
    $display("\033[42;37m************** THIS IS RANDOM TESTING **************\033[0m");
    repeat(RUN_TEST)
    begin
      random_input(pass, fail);
    end
    `else
    //generated input task call
    $display("\033[42;37m************** THIS IS SEQUENCE TESTING **************\033[0m");
    generated_input(pass, fail);
`endif

`ifdef RANDOM_TEST

    if (pass == (NUM_ELEM*RUN_TEST))
`else
    if (pass == (NUM_ELEM))
`endif

    begin
      pass = 1;
    end
    else
    begin
      fail = 1;
    end

    if (pass)
      result_print(pass, "All elements of MUX Passed");
    else
      result_print(fail, "All/few elements of MUX failed");

    $finish;

  end

endmodule
