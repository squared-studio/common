// Register file for floating point
// ### Author : Md. Mohiuddin Reyad (mreyad30207@gmail.com)

module rv_float_reg_file #(
    parameter int FLEN = 32
) (
    input logic clk_i,   // Global clock
    input logic arst_ni, // Asynchronous reset

    input logic [     4:0] rd_addr_i,  // destination register address
    input logic [FLEN-1:0] rd_data_i,  // read data
    input logic            rd_en_i,    // read enable

    input  logic [     4:0] rs1_addr_i,  // source register 1 address
    output logic [FLEN-1:0] rs1_data_o,  // source register 1 data

    input  logic [     4:0] rs2_addr_i,  // source register 2 address
    output logic [FLEN-1:0] rs2_data_o,  // source register 2 data

    input  logic [     4:0] rs3_addr_i,  // source register 3 address
    output logic [FLEN-1:0] rs3_data_o   // source register 3 data
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [31:0]           demux_en;  // connected with the register enable
  logic [31:0][FLEN-1:0] mux_in;  // input for mux

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  demux #(
      .NUM_ELEM(32)
  ) u_demux_reg (
      .s_i(rd_addr_i),
      .i_i(rd_en_i),
      .o_o(demux_en)
  );

  for (genvar i = 0; i < FLEN; i++) begin : g_reg_array
    register #(
        .ELEM_WIDTH (FLEN),
        .RESET_VALUE('0)
    ) register_dut (
        .clk_i  (clk_i),
        .arst_ni(arst_ni),
        .en_i   (demux_en[i]),
        .d_i    (rd_data_i),
        .q_o    (mux_in[i])
    );
  end

  mux #(
      .ELEM_WIDTH(FLEN),
      .NUM_ELEM  (32)
  ) u_mux_rs1 (
      .s_i(rs1_addr_i),
      .i_i(mux_in),
      .o_o(rs1_data_o)
  );

  mux #(
      .ELEM_WIDTH(FLEN),
      .NUM_ELEM  (32)
  ) u_mux_rs2 (
      .s_i(rs2_addr_i),
      .i_i(mux_in),
      .o_o(rs2_data_o)
  );

  mux #(
      .ELEM_WIDTH(FLEN),
      .NUM_ELEM  (32)
  ) u_mux_rs3 (
      .s_i(rs3_addr_i),
      .i_i(mux_in),
      .o_o(rs3_data_o)
  );

endmodule
