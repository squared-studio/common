////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : ...
//    DESCRIPTION : ...
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module round_robin_arbiter_tb;

  // Parameters
  localparam CLOG2_NUM_REQ = 4;
  localparam NUM_REQ = (2 ** CLOG2_NUM_REQ);

  // Ports
  logic clk_i = 1;
  logic arst_n = 1;
  logic [NUM_REQ-1:0] req;
  logic [NUM_REQ-1:0] gnt;

  round_robin_arbiter #(
      .CLOG2_NUM_REQ(CLOG2_NUM_REQ)
  ) round_robin_arbiter_dut (
      .clk_i(clk_i),
      .arst_n(arst_n),
      .req(req),
      .gnt(gnt)
  );

  initial begin
    $dumpfile("raw.vcd");
    $dumpvars();
    req <= '0;
    arst_n = 1;
    #10;
    arst_n = 0;
    #10;
    arst_n = 1;
    #10;
    req <= 'h5a5a;
    repeat (50) begin
      @(posedge clk_i);
    end
    $finish;
  end

  always #5 clk_i = !clk_i;

endmodule
