////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : xbar
//    DESCRIPTION : general purpose xbar
//
////////////////////////////////////////////////////////////////////////////////////////////////////

/*
                                           ------------
                                          ¦            ¦
            [NumElem][ElemWidth] inputs_i →            → [NumElem][ElemWidth] outputs_o
                                          ¦    xbar    ¦
[NumElem][$clog2(NumElem)] input_select_i →            ¦
                                          ¦            ¦
                                           ------------
*/

module xbar #(
    parameter int ElemWidth = 8,
    parameter int NumElem   = 6
) (
    input  logic [NumElem-1:0][$clog2(NumElem)-1:0] input_select_i,
    input  logic [NumElem-1:0][      ElemWidth-1:0] inputs_i,
    output logic [NumElem-1:0][      ElemWidth-1:0] outputs_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  always_comb begin : main
    for (int i = 0; i < NumElem; i++) begin
      outputs_o [i] = (input_select_i[i]<NumElem) ? inputs_i[input_select_i[i]]
                : inputs_i[input_select_i[i]-NumElem];
    end
  end

endmodule
