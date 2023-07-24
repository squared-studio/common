// Testbench for mux
// ### Author : Md. Mohiuddin Reyad (mreyad30207@gmail.com)

module mux_tb #(
    parameter int ELEM_WIDTH = 8,
    parameter int NUM_ELEM   = 6
);

  `define ENABLE_DUMPFILE
  `define DEBUG   //comment this to turn off mux elements display

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
  task static random_input(output int pass, output int fail);  //TODO: static/dynamic?
    for (int i = 0; i < NUM_ELEM; i++) begin
      inputs_i[i] = $urandom_range(0, 2 ** ELEM_WIDTH);
`ifdef DEBUG
      $display("inputs_i[%0d] =%0d", i, inputs_i[i]);
`endif  //DEBUG
    end

    foreach (inputs_i[i]) begin
      sel_i = $urandom_range(0, NUM_ELEM);
      #2;
`ifdef DEBUG
      $display("sel_i = %0d,output_o = %0d", sel_i, output_o);
`endif  //DEBUG
      if (inputs_i[sel_i] != output_o) fail++;
      else pass++;
    end

  endtask

  // input data will be provided from user
  task static user_input(input logic [NUM_ELEM-1:0][ELEM_WIDTH-1:0] inputs,
                         input logic [$clog2(NUM_ELEM)-1:0] sel, output int pass, output int fail);
    inputs_i = inputs;  // TODO: iverilog does not support ths assign style
    sel_i = sel;
    #2;
    $display("sel_i=%0d, inputs_i=%0d", sel_i, inputs_i);

  endtask

  // input data is generated sequentially
  task static generated_input(output int pass, output int fail);
    for (int i = 0; i < NUM_ELEM; i++) begin
      inputs_i[i] = i + NUM_ELEM;
`ifdef DEBUG
      $display("inputs_i[%0d] =%0d", i, inputs_i[i]);
`endif  //DEBUG
    end
    foreach (inputs_i[i]) begin
      sel_i = $urandom_range(0, NUM_ELEM);
      #2;
`ifdef DEBUG
      $display("sel_i = %0d,output_o = %0d", sel_i, output_o);
`endif  //DEBUG
      if (inputs_i[sel_i] != output_o) fail++;
      else pass++;
    end
  endtask

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-PROCEDURALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  initial begin
    int pass;
    int fail;
    // random_input task call
    //random_input(pass, fail);

    //user input task call
    //user_input({8'd10, 8'd3, 8'd4, 8'd5, 8'd6, 8'd7}, 3'd0, pass, fail);  //TODO: fix issue

    //generated input task call
    generated_input(pass, fail);

    if (pass == NUM_ELEM) begin
      pass = 1;
    end else begin
      fail = 1;
    end

    if (pass) result_print(pass, "All elements of MUX Passed");
    else result_print(fail, "All/few elements of MUX failed");

    $finish;

  end

endmodule
