// A simple non-stallable xbar
// ### Author : Foez Ahmed (foez.official@gmail.com)

module xbar #(
    parameter int ElemWidth = 8, // Width of each crossbar element
    parameter int NumElem   = 6 // Number of elements in the crossbar
) (
    input  logic [NumElem-1:0][$clog2(NumElem)-1:0] select_i, // Input bus select
    input  logic [NumElem-1:0][      ElemWidth-1:0] inputs_i, // Array of input bus
    output logic [NumElem-1:0][      ElemWidth-1:0] outputs_o // Array of output bus
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // Drive output bus according to input bus select
  always_comb begin : assign_output
    for (int i = 0; i < NumElem; i++) begin
      outputs_o [i] = (select_i[i]<NumElem) ? inputs_i[select_i[i]] : inputs_i[select_i[i]-NumElem];
    end
  end

endmodule
