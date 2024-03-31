/*
Write a markdown documentation for this systemverilog module:
Author : Foez Ahmed (foez.official@gmail.com)
*/

module mux_primitive #(
    parameter int ELEM_WIDTH = 8,  // Width of each mux input element
    parameter int NUM_ELEM   = 6   // Number of elements in the mux
) (
    input logic [NUM_ELEM-1:0] s_i,  // select

    input logic [NUM_ELEM-1:0][ELEM_WIDTH-1:0] i_i,  // Array of input bus

    output logic [ELEM_WIDTH-1:0] o_o  // Output bus
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  wire [ELEM_WIDTH-1:0] out;  // multi driven output

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  for (genvar i = 0; i < NUM_ELEM; i++) begin : g_drive
    assign out = s_i[i] ? i_i[i] : 'z;
  end

  for (genvar i = 0; i < ELEM_WIDTH; i++) begin : g_buff_out
    buf (out[i], o_o[i]);
  end

endmodule
