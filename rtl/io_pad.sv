/*
The `io_pad` module is a SystemVerilog module that implements an I/O pad. The module uses a
pull-down buffer, a data drive buffer, and a read data buffer to control the I/O pad.
Author : Foez Ahmed (foez.official@gmail.com)
<br>This file is part of squared-studio:common
<br>Copyright (c) 2025 squared-studio
<br>Licensed under the MIT License
<br>See LICENSE file in the project root for full license information
*/

module io_pad #(
    //-PARAMETERS
) (
    input wire pull_i,   // pull-down control signal
    input wire wdata_i,  // write data signal
    input wire wen_i,    // write enable signal

    output wire rdata_o,  // read data signal

    inout wire pin_io  // I/O pad pin
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // This buffer pulls down `pin_io` when `pull_i` is `1` and `wdata_i` is `0`
  bufif1 (pull1, pull0) pull_down (pin_io, wdata_i, pull_i);
  // This buffer drives `pin_io` with `wdata_i` when `wen_i` is `1`
  bufif1 (strong1, strong0) wdata_drive (pin_io, wdata_i, wen_i);
  // This buffer drives `rdata_o` with `pin_io`
  buf (strong1, strong0) read_data (rdata_o, pin_io);

endmodule
