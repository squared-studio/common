/*
The `uart_parity_checker` module is a parity checker for UART (Universal Asynchronous Receiver/Transmitter) data.
Author: Foez Ahmed (foez.official@gmail.com)
*/

module uart_parity_checker #(
    //-PARAMETERS
    //-LOCALPARAMS
) (
    // A 2-bit logic input representing the size of the data
    input logic [1:0] data_size,
    // An 8-bit logic input representing the data to be checked
    input logic [7:0] data,

    // A logic output representing the even parity of the data
    output logic even_parity,
    // A logic output representing the odd parity of the data
    output logic odd_parity
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // An 8-bit logic signal used for intermediate computations
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
