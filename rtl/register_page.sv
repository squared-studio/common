// ### memory page for storing data
// ### Author : Razu Ahamed (en.razu.ahamed@gmail.com)

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
  logic [ELEM_WIDTH-1:0] [          18:0]demux_out;
  logic [ELEM_WIDTH-1:0][2:0] mux_in;
  assign demux_in = {addr[12:3], en_i, in};

  for (genvar i = 0; i < ELEM_WIDTH; i++) begin : g_col_num
    register_column #(
        .ELEM_WIDTH (8),
        .RESET_VALUE('0)
    ) u_register_column (
        .in({
          demux_out[i][7],
          demux_out[i][6],
          demux_out[i][5],
          demux_out[i][4],
          demux_out[i][3],
          demux_out[i][2],
          demux_out[i][1],
          demux_out[i][0]
        }),
        .addr({
          demux_out[i][18],
          demux_out[i][17],
          demux_out[i][16],
          demux_out[i][15],
          demux_out[i][14],
          demux_out[i][13],
          demux_out[i][12],
          demux_out[i][11],
          demux_out[i][10],
          demux_out[i][9] 
        }),
        .clk_i(clk_i),
        .arst_ni(arst_ni),
        .en_i(demux_out[i][8]),
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
