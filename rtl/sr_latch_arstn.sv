// SR latch with arst_ni
// ### Author : Foez Ahmed (foez.official@gmail.com)

module sr_latch_arstn (
    input logic arst_ni,  // asynchronous reset

    input logic s_i,  // set
    input logic r_i,  // reset

    output logic q_o,  // q
    output logic q_no  // ~q
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  nand g0 (and_r_arst, ~r_i, arst_ni);
  nor g1 (q_o, and_r_arst, q_no);
  nor g2 (q_no, s_i, q_o);

endmodule
