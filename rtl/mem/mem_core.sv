////////////////////////////////////////////////////////////////////////////////////////////////////
//
// ### Author : Foez Ahmed (foez.official@gmail.com)
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module mem_core #(
    parameter int ElemWidth = 8,
    parameter int AddrWidth = 8
) (
    input  logic                 clk_i,
    input  logic                 we_i,
    input  logic [AddrWidth-1:0] addr_i,
    input  logic [ElemWidth-1:0] wdata_i,
    output logic [ElemWidth-1:0] rdata_o
);

  localparam int Depth = (2 ** AddrWidth);

  logic [Depth-1:0][ElemWidth-1:0] mem;

  assign rdata_o = mem[addr_i];

  // writes data in memory when we_i is HIGH at the posedge of clk_i
  always_ff @(posedge clk_i) begin : mem_write
    if (we_i) begin
      mem[addr_i] <= wdata_i;
    end
  end

endmodule
