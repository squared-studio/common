/* 
              clk_i       we_n
             ---↓----------↓---
            ¦                  ¦
       addr →     mem_core     ¦
  [8] wdata →                  → [8] rdata
            ¦                  ¦
             ------------------
*/

module mem_bank #(
  parameter CELL_WIDTH = 8,
  parameter ADDR_WIDTH = 8,
  parameter DATA_SIZE  = 2,
  localparam DATA_BYTES = (2**DATA_SIZE),
  localparam DATA_WIDTH = (8*(2**DATA_SIZE))
) (
  input  logic                  clk_i,
  input  logic [ADDR_WIDTH-1:0] addr,
  input  logic [DATA_WIDTH-1:0] wdata,
  input  logic [DATA_BYTES-1:0] wstrb,
  output logic [DATA_WIDTH-1:0] rdata
);

  generate
    for (genvar i = 0; i < DATA_BYTES; i++) begin
      mem_core #(
        .CELL_WIDTH ( CELL_WIDTH             ),
        .ADDR_WIDTH ( ADDR_WIDTH - DATA_SIZE )
      ) u_mem_core (
        .clk_i ( clk_i                        ),
        .addr  ( addr[ADDR_WIDTH-1:DATA_SIZE] ),
        .we    ( wstrb[i]                     ),
        .wdata ( wdata[(8*(i+1)-1):(8*i)]     ),
        .rdata ( rdata[(8*(i+1)-1):(8*i)]     )
      );    
    end
  endgenerate

endmodule