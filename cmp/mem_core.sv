/* 
                       clk_i       we_n
                      ---↓----------↓---
                     ¦                  ¦
                addr →     mem_core     ¦
  [CELL_WIDTH] wdata →                  → [CELL_WIDTG] rdata
                     ¦                  ¦
                      ------------------
*/

module mem_core #(
  parameter  CELL_WIDTH = 8,
  parameter  ADDR_WIDTH = 8,
  localparam DEPTH      = (2**ADDR_WIDTH)
) (
  input  logic                  clk_i,
  input  logic                  cs,
  input  logic                  we,
  input  logic [ADDR_WIDTH-1:0] addr,
  input  logic [CELL_WIDTH-1:0] wdata,
  output logic [CELL_WIDTH-1:0] rdata
);

  logic [DEPTH-1:0][CELL_WIDTH-1:0] mem;

  logic do_write;
  
  assign rdata = cs ? mem [addr] : 'z;

  assign do_write = cs & we;

  always_ff @( posedge clk_i ) begin 
    if (do_write) begin
      mem[addr] <= wdata;
    end
  end

endmodule
