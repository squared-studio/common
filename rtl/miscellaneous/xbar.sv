// A simple non-stallable xbar
// ### Author : Foez Ahmed (foez.official@gmail.com)

module xbar #(
    parameter int ELEM_WIDTH = 8,  // Width of each crossbar element
    parameter int NUM_ELEM   = 6   // Number of elements in the crossbar
) (
    input  logic [NUM_ELEM-1:0][$clog2(NUM_ELEM)-1:0] select_i,  // Input bus select
    input  logic [NUM_ELEM-1:0][      ELEM_WIDTH-1:0] inputs_i,  // Array of input bus
    output logic [NUM_ELEM-1:0][      ELEM_WIDTH-1:0] outputs_o  // Array of output bus
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // Drive output bus according to input bus select
  always_comb begin : assign_output
    for (int i = 0; i < NUM_ELEM; i++) begin
      outputs_o [i] = (select_i[i]<NUM_ELEM) ? inputs_i[select_i[i]] :
       inputs_i[select_i[i]-NUM_ELEM];
    end
  end

endmodule
