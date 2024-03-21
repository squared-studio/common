// A simple memory building block.
// ### Author : Foez Ahmed (foez.official@gmail.com)

module mem_core #(
    parameter  int ELEM_WIDTH = 8,                 // Width of each memory data element
    parameter  int ADDR_WIDTH = 8,                 // Width of the address bus
    localparam int Depth      = (2 ** ADDR_WIDTH)  // Depth of the memory
) (
    input logic clk_i,  // Global clock

    input logic                  we_i,    // Write enable
    input logic [ADDR_WIDTH-1:0] addr_i,  // Address bus input
    input logic [ELEM_WIDTH-1:0] wdata_i, // Write data

    output logic [ELEM_WIDTH-1:0] rdata_o  // Read data
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [Depth-1:0][ELEM_WIDTH-1:0] mem;  // Memory

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign rdata_o = mem[addr_i];  // Assigning read data

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-METHODS
  //////////////////////////////////////////////////////////////////////////////////////////////////

`ifdef SIMULATION

  // Writes the provided data directly into the memory at the provided address
  function automatic void backdoor_write(input bit [ADDR_WIDTH-1:0] addr,
                                         input bit [ELEM_WIDTH-1:0] data);
    mem[addr] = data;
  endfunction

  // Read data directly from the memory at the provided address
  function automatic logic [ELEM_WIDTH-1:0] backdoor_read(input bit [ADDR_WIDTH-1:0] addr);
    return mem[addr];
  endfunction

`endif  //SIMULATION

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SEQUENTIAL
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // Writes data in memory when we_i is HIGH at the posedge of clk_i
  always_ff @(posedge clk_i) begin : mem_write
    if (we_i) begin
      mem[addr_i] <= wdata_i;
    end
  end

endmodule
