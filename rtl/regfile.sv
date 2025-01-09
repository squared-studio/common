/*
The `regfile` module is a register file with a configurable number of source registers, register
width, and an option to hardcode zero to the first register.
Author: Md. Mohiuddin Reyad (mreyad30207@gmail.com)
<br>This file is part of squared-studio:common
<br>Copyright (c) 2025 squared-studio
<br>Licensed under the MIT License
<br>See LICENSE file in the project root for full license information
*/

module regfile #(
    parameter int NUM_RS = 3,     // number of source register
    parameter bit ZERO_REG = 1,   // hardcoded zero(0) to first register
    parameter int NUM_REG = 32,   // number of registers
    parameter int REG_WIDTH = 32  // width of each register
) (
    input logic clk_i,   // Global clock
    input logic arst_ni, // asynchronous active low reset

    input logic [$clog2(NUM_REG)-1:0] rd_addr_i,  // destination register address
    input logic [      REG_WIDTH-1:0] rd_data_i,  // read data
    input logic                       rd_en_i,    // read enable

    input logic [NUM_RS-1:0][$clog2(NUM_REG)-1:0] rs_addr_i,  // array of source register address

    output logic [NUM_RS-1:0][REG_WIDTH-1:0] rs_data_o  // array of source register data
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [NUM_REG-1:0]                demux_en;  // connected with the register enable
  logic [NUM_REG-1:0][REG_WIDTH-1:0] mux_in;  // input for mux

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  if (ZERO_REG) begin : g_zero
    assign mux_in[0] = '0;
  end

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  demux #(
      .NUM_ELEM  (NUM_REG),
      .ELEM_WIDTH(1)
  ) u_demux_reg (
      .s_i(rd_addr_i),
      .i_i(rd_en_i),
      .o_o(demux_en)
  );

  for (genvar i = ZERO_REG; i < NUM_REG; i++) begin : g_reg_array
    register #(
        .ELEM_WIDTH (REG_WIDTH),
        .RESET_VALUE('0)
    ) register_dut (
        .clk_i  (clk_i),
        .arst_ni(arst_ni),
        .en_i   (demux_en[i]),
        .d_i    (rd_data_i),
        .q_o    (mux_in[i])
    );
  end

  for (genvar i = 0; i < NUM_RS; i++) begin : g_mux_array
    mux #(
        .ELEM_WIDTH(REG_WIDTH),
        .NUM_ELEM  (NUM_REG)
    ) u_mux_rs (
        .s_i(rs_addr_i[i]),
        .i_i(mux_in),
        .o_o(rs_data_o[i])
    );
  end

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-INITIAL CHECKS
  //////////////////////////////////////////////////////////////////////////////////////////////////

`ifdef SIMULATION
  initial begin
    if (NUM_REG > 64) begin
      $display("\033[7;31m%m TOO MANY REGISTERS!!\033[0m");
    end
  end
`endif  // SIMULATION

endmodule
