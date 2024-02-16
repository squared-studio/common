// Glitch free clocking mux
// ### Author : Foez Ahmed (foez.official@gmail.com)

module clk_mux #(
) (
    input  logic arst_ni,
    input  logic clk0_i,
    input  logic clk1_i,
    input  logic sel_i,
    output logic clk_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic clk0_ffb2b_in;
  logic clk1_ffb2b_in;

  logic clk0_ffb2b_out;
  logic clk1_ffb2b_out;

  logic clk0_and;
  logic clk1_and;

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign clk0_ffb2b_in = ~( sel_i | clk1_ffb2b_out);
  assign clk1_ffb2b_in = ~(~sel_i | clk0_ffb2b_out);

  assign clk0_and = clk0_ffb2b_out & clk0_i;
  assign clk1_and = clk1_ffb2b_out & clk1_i;

  assign clk_o = clk0_and | clk1_and;

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  dual_synchronizer #(
    .FIRST_FF_EDGE_POSEDGED (1),
    .LAST_FF_EDGE_POSEDGED  (0)
  ) clk0_ffb2b (
      .clk_i  (clk0_i),
      .arst_ni(arst_ni),
      .en_i   ('1),
      .d_i    (clk0_ffb2b_in),
      .q_o    (clk0_ffb2b_out)
  );

  dual_synchronizer #(
    .FIRST_FF_EDGE_POSEDGED (1),
    .LAST_FF_EDGE_POSEDGED  (0)
  ) clk1_ffb2b (
      .clk_i  (clk1_i),
      .arst_ni(arst_ni),
      .en_i   ('1),
      .d_i    (clk1_ffb2b_in),
      .q_o    (clk1_ffb2b_out)
  );

  //}}}

endmodule
