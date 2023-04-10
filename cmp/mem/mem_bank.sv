/* 
                       clk_i        cs
                      ---↓----------↓---
                     ¦                  ¦
                addr →                  ¦
  [DATA_WIDTH] wdata →     mem_bank     → [DATA_WIDTH] rdata
  [DATA_BYTES] wstrb →                  ¦
                     ¦                  ¦
                      ------------------
*/

module mem_bank #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_SIZE  = 2,
    localparam DATA_BYTES = (2**DATA_SIZE),
    localparam DATA_WIDTH = (8*(2**DATA_SIZE))
) (
    input  logic                  clk_i,
    input  logic                  cs,
    input  logic [ADDR_WIDTH-1:0] addr,
    input  logic [DATA_WIDTH-1:0] wdata,
    input  logic [DATA_BYTES-1:0] wstrb,
    output logic [DATA_WIDTH-1:0] rdata
);

    generate
        for (genvar i = 0; i < DATA_BYTES; i++) begin
            mem_core #(
                .CELL_WIDTH ( 8                      ),
                .ADDR_WIDTH ( ADDR_WIDTH - DATA_SIZE )
            ) u_mem_core (
                .clk_i ( clk_i                        ),
                .cs    ( cs                           ),
                .we    ( wstrb[i]                     ),
                .addr  ( addr[ADDR_WIDTH-1:DATA_SIZE] ),
                .wdata ( wdata[(8*(i+1)-1):(8*i)]     ),
                .rdata ( rdata[(8*(i+1)-1):(8*i)]     )
            );    
        end
    endgenerate

endmodule