/*
Write a markdown documentation for this systemverilog module:
Author : Md. Mohiuddin Reyad (mreyad30207@gmail.com)
*/

module rv_vec_reg_file #(
    parameter int VLEN = 128
) (
    input logic clk_i,   // Global clock
    input logic arst_ni, // Asynchronous reset

    input logic [     4:0] rd_addr_i,  // destination register address
    input logic [VLEN-1:0] rd_data_i,  // read data
    input logic            rd_en_i,    // read enable

    input  logic [     4:0] rs1_addr_i,  // source register 1 address
    output logic [VLEN-1:0] rs1_data_o,  // source register 1 data

    input  logic [     4:0] rs2_addr_i,  // source register 2 address
    output logic [VLEN-1:0] rs2_data_o,  // source register 2 data

    input  logic [     4:0] rs3_addr_i,  // source register 3 address
    output logic [VLEN-1:0] rs3_data_o   // source register 3 data
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [2:0][     4:0] rs_addr_i;  // address array to the reg file
  logic [2:0][VLEN-1:0] rs_data_o;  // data array from the reg file

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign rs_addr_i[0] = rs1_addr_i;
  assign rs1_data_o   = rs_data_o[0];
  assign rs_addr_i[1] = rs1_addr_i;
  assign rs1_data_o   = rs_data_o[1];
  assign rs_addr_i[2] = rs1_addr_i;
  assign rs1_data_o   = rs_data_o[2];

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  reg_file #(
      .NUM_RS(3),
      .ZERO_REG(0),
      .NUM_REG(32),
      .REG_WIDTH(VLEN)
  ) u_reg_file (
      .clk_i(clk_i),
      .arst_ni(arst_ni),
      .rd_addr_i(rd_addr_i),
      .rd_data_i(rd_data_i),
      .rd_en_i(rd_en_i),
      .rs_addr_i(rs_addr_i),
      .rs_data_o(rs_data_o)
  );

endmodule
