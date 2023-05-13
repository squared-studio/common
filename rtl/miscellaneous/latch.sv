////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : latch
//    DESCRIPTION : general purpose latch
//
////////////////////////////////////////////////////////////////////////////////////////////////////

/*
                 ------------------------
                ¦                        ¦
[ElemWidth] d_i →                        → [ElemWidth] q_o
                ¦    priority_encoder    ¦
           en_i →                        ¦
                ¦                        ¦
                 ------------------------
*/

module latch #(
    parameter int ElemWidth = 8
) (
    input  logic                 en_i,
    input  logic [ElemWidth-1:0] d_i,
    output logic [ElemWidth-1:0] q_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  always @(en_i or d_i) begin : main
    if (en_i) q_o <= d_i;
  end

endmodule
