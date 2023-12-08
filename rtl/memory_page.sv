// ### memory page for storing data
// ### Author : Razu Ahamed (en.razu.ahamed@gmail.com)

`include "./memory_column.sv"
`include "./mux.sv"
`include "./demux.sv"
module memory_page #(
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
  logic [ELEM_WIDTH-1:0][7:0] mux_in;
  assign demux_in = {addr[12:3], en_i, in};

  for (genvar i = 0; i < 8; i++) begin : g_col_num
    memory_column #(
        .ELEM_WIDTH (8),
        .RESET_VALUE('0)
    ) u_memory_column (
        .in(demux_out[i][7:0]),
        .addr(demux_out[i][18:9]),
        .clk_i(clk_i),
        .arst_ni(arst_ni),
        .en_i(demux_out[i][8]),
        .out(mux_in[i])
    );
  end

  mux #(
      .ELEM_WIDTH(8),    // Width of each mux input element
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
