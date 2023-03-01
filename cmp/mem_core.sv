/* 
              clk_i       we_n
             ---↓----------↓---
            ¦                  ¦
       addr →     mem_core     ¦
  [8] wdata →                  → [8] rdata
            ¦                  ¦
             ------------------
*/

module mem_core #(
  parameter  CELL_WIDTH = 8,
  parameter  ADDR_WIDTH = 8,
  localparam DEPTH      = (2**ADDR_WIDTH)
) (
  input  logic                  clk_i,
  input  logic [ADDR_WIDTH-1:0] addr,
  input  logic                  we,
  input  logic [CELL_WIDTH-1:0] wdata,
  output logic [CELL_WIDTH-1:0] rdata
);

  logic [DEPTH-1:0][CELL_WIDTH-1:0] mem;
  
  assign rdata = mem [addr];

  always_ff @( posedge clk_i ) begin 
    if (we) begin
      mem[addr] <= wdata;
    end
  end

endmodule
