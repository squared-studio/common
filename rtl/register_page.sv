`include "./register_column.sv"
`include "./mux.sv"
`include "./demux.sv"
module register_page #(
    parameter int ELEM_WIDTH = 8
) (
    input  logic [ELEM_WIDTH-1:0] in,
    input  logic [          12:0] addr,
    input  logic                  clk_i,
    input  logic                  arst_ni,
    input  logic                  en_i,
    output logic [ELEM_WIDTH-1:0] out
);
  logic [          18:0]      demux_in;
  logic [          18:0][2:0] demux_out;
  logic [ELEM_WIDTH-1:0][2:0] mux_in;
  assign demux_in = {addr[12:3], en_i, in};

  for (genvar i = 0; i < 8; i++) begin : g_col_num
    register_column #(
        .ELEM_WIDTH (8),
        .RESET_VALUE('0)
    ) u_register_column (
        .in({
          demux_out[7][i],
          demux_out[6][i],
          demux_out[5][i],
          demux_out[4][i],
          demux_out[3][i],
          demux_out[2][i],
          demux_out[1][i],
          demux_out[0][i]
        }),
        .addr({
          demux_out[19][i],
          demux_out[18][i],
          demux_out[17][i],
          demux_out[16][i],
          demux_out[15][i],
          demux_out[14][i],
          demux_out[13][i],
          demux_out[12][i],
          demux_out[11][i],
          demux_out[10][i],
          demux_out[9][i]
        }),
        .clk_i(clk_i),
        .arst_ni(arst_ni),
        .en_i(demux_out[8][i]),
        .out(mux_in[i])
    );
  end

  mux #(
      .ELEM_WIDTH(10),    // Width of each mux input element
      .NUM_ELEM  (8)  // Number of elements in the mux
  ) u_mux (
      .s_i(addr[2:0]),  // select
      .i_i(mux_in),   // Array of input bus
      .o_o(out)    // Output bus
  );

  demux #(
      .NUM_ELEM  (8),  // Number of elements in the demux
      .ELEM_WIDTH(19)  // Width of each element
  ) u_demux (
      .s_i(addr[2:0]),  // Output select
      .i_i(demux_in),   // input
      .o_o(demux_out)   // Array of Output
  );
endmodule
