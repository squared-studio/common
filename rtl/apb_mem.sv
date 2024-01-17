// Description
// ### Author : Foez Ahmed (foez.official@gmail.com)

module apb_mem #(
    //-PARAMETERS
    parameter int ADDR_WIDTH  = 32,
    parameter int DATA_WIDTH  = 32,
    parameter int MEMORY_SIZE = 18
) (
    input logic PCLK,
    input logic PRESETn,

    input logic [  ADDR_WIDTH-1:0] PADDR,
    input logic                    PSEL,
    input logic                    PENABLE,
    input logic                    PWRITE,
    input logic [  DATA_WIDTH-1:0] PWDATA,
    input logic [DATA_WIDTH/8-1:0] PSTRB,

    output logic                  PREADY,
    output logic [DATA_WIDTH-1:0] PRDATA,
    output logic                  PSLVERR
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-LOCALPARAMS GENERATED{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  localparam int DATA_SIZE = $clog2(DATA_WIDTH / 8);

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [DATA_WIDTH/8-1:0] anded_strb;

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  for (genvar i = 0; i < DATA_WIDTH/8; i++) begin : g_anded_strb
    assign anded_strb[i] = PSTRB[i] & PWRITE;
  end
  assign PSLVERR = |PADDR[ADDR_WIDTH-1:MEMORY_SIZE];
  assign PREADY  = '1;

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  mem_bank #(
      .ADDR_WIDTH(MEMORY_SIZE),
      .DATA_SIZE (DATA_SIZE)
  ) u_mem_bank (
      .clk_i  (PCLK),
      .cs_i   (PRESETn & PSEL & PENABLE & ~PSLVERR),
      .addr_i (PADDR[MEMORY_SIZE-1:0]),
      .wdata_i(PWDATA),
      .wstrb_i(anded_strb),
      .rdata_o(PRDATA)
  );

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-INITIAL CHECKS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

`ifdef SIMULATION
  initial begin
    if (ADDR_WIDTH > 10) begin
      $display("\033[7;31m%m ADDE_WIDTH might be too large for combinational logic RDATA\033[0m");
    end
  end
`endif  // SIMULATION

  //}}}

endmodule
