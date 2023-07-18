// Mux with direct output select
// ### Author : Foez Ahmed (foez.official@gmail.com)

module mux_core #(
    parameter int ELEM_WIDTH = 8,  // Width of each crossbar element
    parameter int NUM_ELEM   = 6   // Number of elements in the crossbar
  ) (
    input  logic [$clog2(NUM_ELEM)-1:0]           sel_i,     // Output enable
    input  logic [  NUM_ELEM-1:0][ELEM_WIDTH-1:0] inputs_i,  // Array of input bus
    output logic [ELEM_WIDTH-1:0]                 output_o   // Array of output bus
  );

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  wire [ELEM_WIDTH-1:0] out;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  for (genvar i = 0; i < NUM_ELEM; i++)
  begin : g_out
    assign out = (sel_i == i) ? inputs_i[i] : 'z;
  end

  assign output_o = out;

endmodule
