/*
Author : Foez Ahmed (foez.official@gmail.com)
This file is part of squared-studio:common
Copyright (c) 2024 squared-studio
Licensed under the MIT License
See LICENSE file in the project root for full license information
*/

`ifndef MEMORY_PKG_SV
`define MEMORY_PKG_SV

package memory_pkg;

  `include "vip/memory_ops.svh"

  class byte_memory;
    //////////////////////////////////////////////////////////////////////////////////////////////////
    //-SIGNALS
    //////////////////////////////////////////////////////////////////////////////////////////////////

    bit [7:0] mem[longint];

    //////////////////////////////////////////////////////////////////////////////////////////////////
    //-METHODS
    //////////////////////////////////////////////////////////////////////////////////////////////////

    function automatic load_image(input string file);
      `LOAD_HEX(file, mem)
    endfunction

    function automatic save_image(input string file);
      `SAVE_HEX(file, mem)
    endfunction

  endclass

endpackage

`endif
