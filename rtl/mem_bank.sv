// Memory bank with byte size storage. **All requests must be aligned**
// ### Author : Foez Ahmed (foez.official@gmail.com)

//`define SIMULATION

module mem_bank #(
    parameter  int ADDR_WIDTH = 8,               // Memory bank address width
    parameter  int DATA_SIZE  = 2,               // log2(bytes_in_databus)
    localparam int DataBytes  = 2 ** DATA_SIZE,  // Bytes in the data bus
    localparam int DataBits   = 8 * DATA_SIZE    // Bits in the data bus

) (
    input logic clk_i,  // Global clock
    input logic cs_i,   // Asynchronous reset

    input logic [        ADDR_WIDTH-1:0] addr_i,   // Aligned byte address
    input logic [(8*(2**DATA_SIZE))-1:0] wdata_i,  // Aligned write data
    input logic [    (2**DATA_SIZE)-1:0] wstrb_i,  // Aligned write strobe

    output logic [(8*(2**DATA_SIZE))-1:0] rdata_o  // Aligned read data
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
