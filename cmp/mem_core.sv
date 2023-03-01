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
  parameter ADDR_WIDTH = 8
) (
  input  logic                  clk_i,
  input  logic [ADDR_WIDTH-1:0] addr,
  input  logic                  we_n,
  input  logic [7:0]            wdata,
  output logic [7:0]            rdata
);

  logic [7:0] mem [2**ADDR_WIDTH];
  
  assign rdata = mem [addr];

  always_ff @( posedge clk_i ) begin 
    if (~we_n) begin
      mem[addr] <= wdata;
    end
  end

endmodule