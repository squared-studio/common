/*
The `sr_latch_arstn` module is an SR latch with asynchronous active low reset.
Author: Foez Ahmed (foez.official@gmail.com)
*/

module sr_latch_arstn (
    input logic arst_ni,  // asynchronous active low reset input

    input logic s_i,  // set input
    input logic r_i,  // reset input

    output logic q_o,  // Q output
    output logic q_no  // inverted Q output
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  nand g0 (and_r_arst, ~r_i, arst_ni);
  nor g1 (q_o, and_r_arst, q_no);
  nor g2 (q_no, s_i, q_o);

endmodule
