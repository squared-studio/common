/*
The `mem_bank` module is a parameterized SystemVerilog module that implements a memory bank. The
module uses a loop to generate multiple instances of the `mem_core` module, each with its own write
enable signal.
Author : Foez Ahmed (foez.official@gmail.com)
*/

module mem_bank #(
    // width of the memory bank address
    parameter  int ADDR_WIDTH = 8,
    // base-2 logarithm of the number of bytes in the data bus
    parameter  int DATA_SIZE  = 2,
    // number of bytes in the data bus
    localparam int DataBytes  = 2 ** DATA_SIZE,
    // number of bits in the data bus
    localparam int DataBits   = 8 * DATA_SIZE
) (
    input logic clk_i,  //The global clock signal
    input logic cs_i,   //The asynchronous active low reset signal

    input logic [        ADDR_WIDTH-1:0] addr_i,   //The aligned byte address
    input logic [(8*(2**DATA_SIZE))-1:0] wdata_i,  //The aligned write data
    input logic [    (2**DATA_SIZE)-1:0] wstrb_i,  //The aligned write strobe

    output logic [(8*(2**DATA_SIZE))-1:0] rdata_o  //The aligned read data
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [DataBytes-1:0] do_write;  // decides write to a memory column

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // generate do_write for each memory column
  for (genvar i = 0; i < DataBytes; i++) begin : g_do_write
    assign do_write[i] = wstrb_i[i] & cs_i;
  end

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // generate memory column with mem_core
  for (genvar i = 0; i < DataBytes; i++) begin : g_mem_cores

    mem_core #(
        .ELEM_WIDTH(8),
        .ADDR_WIDTH(ADDR_WIDTH - DATA_SIZE)
    ) u_mem_core (
        .clk_i  (clk_i),
        .we_i   (do_write[i]),
        .addr_i (addr_i[ADDR_WIDTH-1:DATA_SIZE]),
        .wdata_i(wdata_i[(8*(i+1)-1):(8*i)]),
        .rdata_o(rdata_o[(8*(i+1)-1):(8*i)])
    );

  end

endmodule
