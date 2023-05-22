////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    Author : Foez Ahmed (foez.official@gmail.com)
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module mem_bank #(
    parameter  int AddrWidth = 8,
    parameter  int DataSize  = 2,
    localparam int DataBytes = (2 ** DataSize),
    localparam int DataWidth = (8 * (2 ** DataSize))
) (
    input  logic                 clk_i,
    input  logic                 cs_i,
    input  logic [AddrWidth-1:0] addr_i,
    input  logic [DataWidth-1:0] wdata_i,
    input  logic [DataBytes-1:0] wstrb_i,
    output logic [DataWidth-1:0] rdata_o
);

  for (genvar i = 0; i < DataBytes; i++) begin : g_mem_cores

    logic do_write;
    assign do_write = wstrb_i[i] & cs_i;

    mem_core #(
        .ElemWidth(8),
        .AddrWidth(AddrWidth - DataSize)
    ) u_mem_core (
        .clk_i  (clk_i),
        .we_i   (do_write),
        .addr_i (addr_i[AddrWidth-1:DataSize]),
        .wdata_i(wdata_i[(8*(i+1)-1):(8*i)]),
        .rdata_o(rdata_o[(8*(i+1)-1):(8*i)])
    );

  end

endmodule
