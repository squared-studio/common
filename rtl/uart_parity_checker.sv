// Description
// ### Author : Foez Ahmed (foez.official@gmail.com)

//`include "addr_map.svh"
//`include "axi4l_assign.svh"
//`include "axi4l_typedef.svh"
//`include "axi4_assign.svh"
//`include "axi4_typedef.svh"
//`include "default_param_pkg.sv"

module uart_parity_checker #(
    //-PARAMETERS
    //-LOCALPARAMS
) (
    input logic [1:0] data_size,
    input logic [7:0] data,

    output logic even_parity,
    output logic odd_parity
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [7:0] intermediate_data;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign intermediate_data[4:0] = data[4:0];

  assign intermediate_data[5] = data[5] & (data_size[0] | data_size[1]);
  assign intermediate_data[6] = data[6] & (data_size[1]);
  assign intermediate_data[7] = data[7] & (data_size[0] & data_size[1]);

  assign even_parity = ^intermediate_data;
  assign odd_parity = ~even_parity;
endmodule
