/*
The `mem_core` module is a parameterized SystemVerilog module that implements a memory core. The
module uses a flip-flop to write data into the memory at the positive edge of the clock signal
the write enable signal is high.
Author : Foez Ahmed (foez.official@gmail.com)
*/

module mem_core #(
    parameter  int ELEM_WIDTH = 8,                 // width of each memory data element
    parameter  int ADDR_WIDTH = 8,                 // width of the address bus
    localparam int Depth      = (2 ** ADDR_WIDTH)  // depth of the memory
) (
    input logic clk_i,  // global clock signal

    input logic                  we_i,    // write enable signal
    input logic [ADDR_WIDTH-1:0] addr_i,  // address bus input
    input logic [ELEM_WIDTH-1:0] wdata_i, // write data

    output logic [ELEM_WIDTH-1:0] rdata_o  // read data
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
  //-SEQUENTIALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // Writes data in memory when we_i is HIGH at the posedge of clk_i
  always_ff @(posedge clk_i) begin : mem_write
    if (we_i) begin
      mem[addr_i] <= wdata_i;
    end
  end

endmodule
