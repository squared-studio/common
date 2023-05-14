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
    input  logic                 arst_ni,
    input  logic                 en_i,
    input  logic [ElemWidth-1:0] d_i,
    output logic [ElemWidth-1:0] q_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  always @(en_i or d_i or arst_ni) begin
    if (~arst_ni)
      q_o = '0;
    else if (en_i)
      q_o = d_i;
  end

endmodule
