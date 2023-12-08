// ### memory column for storing data
// ### Author : Razu Ahamed (en.razu.ahamed@gmail.com)

`include "./register.sv"
`include "./mux.sv"
`include "./demux.sv"
module memory_column #(
  parameter int                  ELEM_WIDTH  = 8,
  parameter bit [ELEM_WIDTH-1:0] RESET_VALUE = '0
)
( input  logic [ELEM_WIDTH-1:0]        in,
  input  logic          [9:0]          addr,
  input  logic                         clk_i,
  input  logic                         arst_ni,
  input  logic                         en_i,
  output logic[ELEM_WIDTH-1:0]         out
);

  logic [1023:0][0:0]               demux_en_i;
  logic [1023:0][ELEM_WIDTH-1:0] temp;

  for (genvar i = 0; i < 1024; i++)
  begin : g_row_num
    register #(
        .ELEM_WIDTH(ELEM_WIDTH),
        .RESET_VALUE(RESET_VALUE)
    ) u_register (
      .clk_i  (clk_i),
      .arst_ni(arst_ni),
      .en_i   (demux_en_i[i]),
      .d_i    (in),
      .q_o    (temp[i][7:0])
    );
  end

  mux #(
      .ELEM_WIDTH(8),    // Width of each mux input element
      .NUM_ELEM (1024)   // Number of elements in the mux
  ) u_1_mux(
      .s_i(addr),  // select
      .i_i(temp),   // Array of input bus
      .o_o(out)    // Output bus
  );

  demux #(
      .NUM_ELEM(1024),  // Number of elements in the demux
      .ELEM_WIDTH(1)    // Width of each element
  ) u_1_demux (
      .s_i(addr),       // Output select
      .i_i(en_i),       // input
      .o_o(demux_en_i)    // Array of Output
  );

endmodule
