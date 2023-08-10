// A simple up down counter that counts up to MAX_COUNT
// ### Author : Md. Mohiuddin Reyad (mreyad30207@gmail.com)

module counter #(
    parameter int                           MAX_COUNT   = 25,  // max value of count
    parameter bit [$clog2(MAX_COUNT+1)-1:0] RESET_VALUE = '0,
    parameter bit                           UP_COUNT    = 1,
    parameter bit                           DOWN_COUNT  = 1
) (
    input  logic                           clk_i,
    input  logic                           arst_ni,
    input  logic                           up_i,
    input  logic                           down_i,
    output logic [$clog2(MAX_COUNT+1)-1:0] count_o
);

  logic [$clog2(MAX_COUNT+1)-1:0] mux_out;

  logic [1:0][$clog2(MAX_COUNT+1)-1:0] mux_in;


  logic [$clog2(MAX_COUNT+1)-1:0] delta;

  logic [1:0] mux_sel;


  //if (UP_COUNT && DOWN_COUNT) begin : g_both_ud

  assign delta = down_i ? '1 : 1;

  assign mux_in[0] = '0;
  assign mux_sel[0] = (count_o == MAX_COUNT) && up_i && !down_i;

  assign mux_in[1] = MAX_COUNT;
  assign mux_sel[1] = (count_o == 0) && !up_i && down_i;

  assign mux_in[2] = count_o + delta;
  assign mux_sel[2] = (up_i != down_i);

  assign mux_in[3] = count_o;
  assign mux_sel[3] = (up_i == down_i);

  mux_primitive #(
      .ELEM_WIDTH($clog2(MAX_COUNT + 1)),
      .NUM_ELEM  (4)
  ) mux_primitive_dut (
      .s_i(mux_sel),
      .i_i(mux_in),
      .o_o(mux_out)
  );

  //end


  register #(
      .ELEM_WIDTH ($clog2(MAX_COUNT + 1)),
      .RESET_VALUE(RESET_VALUE)
  ) register_dut (
      .clk_i(clk_i),
      .arst_ni(arst_ni),
      .en_i('1),
      .d_i(mux_out),
      .q_o(count_o)
  );

endmodule
