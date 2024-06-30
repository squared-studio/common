/*
The shifter module performs data shifting operations. It takes input data, shift control signals,
and produces the shifted output data.
Author : Foez Ahmed (foez.official@gmail.com)
*/

module shifter #(
    parameter int DATA_WIDTH  = 4,  // Specifies the width of the input and output data
    parameter int SHIFT_WIDTH = 3   // Determines the number of shift stages
) (
    input logic [DATA_WIDTH-1:0] data_i,  // Input data to be shifted
    input logic [SHIFT_WIDTH-1:0] shift_i,  // Control signal for shifting
    input logic [SHIFT_WIDTH-1:0] right_shift_i,  // Control signal for right shifting

    output logic [DATA_WIDTH-1:0] data_o  // Output data after shifting
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // An array of registers representing intermediate shift stages
  logic [DATA_WIDTH-1:0] stage[SHIFT_WIDTH];

  // Holds the data after initial left/right inversion
  logic [DATA_WIDTH-1:0] lr_init;

  // Holds the data after final left/right inversion
  logic [DATA_WIDTH-1:0] lr_final;


  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  for (genvar i = 0; i < DATA_WIDTH; i++) begin : g_right_shift_invertions
    assign lr_init[i] = right_shift_i ? data_i[DATA_WIDTH-1-i] : data_i[i];
    assign lr_final[i] = right_shift_i ? stage[SHIFT_WIDTH-1][DATA_WIDTH-1-i]
                                       : stage[SHIFT_WIDTH-1][i];
  end

  assign stage[0] = shift_i[0] ? lr_init : '0;
  for (genvar i = 0; i < SHIFT_WIDTH; i++) begin : g_shift_mux
    assign stage[i] = shift_i[i] ? {stage[i-1], {i{1'b0}}} : stage[i-1];
  end

  assign data_o = stage[SHIFT_WIDTH-1];

endmodule
