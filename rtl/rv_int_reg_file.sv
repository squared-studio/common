// Register file for integer
// ### Author : Md. Mohiuddin Reyad (mreyad30207@gmail.com)

module rv_int_reg_file #(
    parameter int XLEN = 32
) (
    input logic clk_i,   // Global clock
    input logic arst_ni, // Asynchronous reset

    input logic [     4:0] rd_addr_i,  // destination register address
    input logic [XLEN-1:0] rd_data_i,  // read data
    input logic            rd_en_i,    // read enable

    input  logic [     4:0] rs1_addr_i,  // source register 1 address
    output logic [XLEN-1:0] rs1_data_o,  // source register 1 data

    input  logic [     4:0] rs2_addr_i,  // source register 2 address
    output logic [XLEN-1:0] rs2_data_o   // source register 2 data
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [1:0][     4:0] rs_addr_i;  // address array to the reg file
  logic [1:0][XLEN-1:0] rs_data_o;  // data array from the reg file

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign rs_addr_i[0] = rs1_addr_i;
  assign rs1_data_o   = rs_data_o[0];
  assign rs_addr_i[1] = rs1_addr_i;
  assign rs1_data_o   = rs_data_o[1];

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  reg_file #(
      .NUM_RS(2),
      .ZERO_REG(1),
      .NUM_REG(32),
      .REG_WIDTH(XLEN)
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
