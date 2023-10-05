// IO pad for GPIO and similar pins
// ### Author : Foez Ahmed (foez.official@gmail.com)

module io_pad #(
    //-PARAMETERS
) (
    input  wire pu_ni,
    input  wire pd_i,
    input  wire wdata_i,
    input  wire wen_i,
    output wire rdata_o,
    inout  wire pin_io
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  buf (weak1, highz0) pull_up (pin_io, !pu_ni);
  buf (highz1, weak0) pull_down (pin_io, pd_i);
  bufif1 (strong1, strong0) wdata_drive (pin_io, wdata_i, wen_i);
  buf read_data (rdata_o, pin_io);

  //}}}

endmodule
