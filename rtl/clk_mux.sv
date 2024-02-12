// Glitch free clocking mux
// ### Author : Foez Ahmed (foez.official@gmail.com)

module clk_mux #(
    parameter int SYNC_STAGES = 2
) (
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

  assign clk0_ffb2b_in = ~sel_i & ~clk1_ffb2b_out;
  assign clk1_ffb2b_in =  sel_i & ~clk0_ffb2b_out;

  assign clk0_and = clk0_ffb2b_out & clk0_i;
  assign clk1_and = clk1_ffb2b_out & clk1_i;

  assign clk_o = clk0_and | clk1_and;

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  ff_back_to_back #(
      .NUM_STAGES(SYNC_STAGES)
  ) clk0_ffb2b (
      .clk_i  (clk0_i),
      .arst_ni('1),
      .en_i   ('1),
      .d_i    (clk0_ffb2b_in),
      .q_o    (clk0_ffb2b_out)
  );

  ff_back_to_back #(
      .NUM_STAGES(SYNC_STAGES)
  ) clk1_ffb2b (
      .clk_i  (clk1_i),
      .arst_ni('1),
      .en_i   ('1),
      .d_i    (clk1_ffb2b_in),
      .q_o    (clk1_ffb2b_out)
  );

  //}}}

endmodule
