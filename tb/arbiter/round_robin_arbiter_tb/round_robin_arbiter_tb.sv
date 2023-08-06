module round_robin_arbiter_tb;

  // Parameters
  localparam int NUM_REQ = 6;

  // Ports
  reg                        clk_i = 0;
  reg                        arst_ni = 0;
  reg                        allow_req_i = 0;
  reg  [        NUM_REQ-1:0] req_i;
  wire [$clog2(NUM_REQ)-1:0] gnt_addr_o;
  wire                       gnt_addr_valid_o;

  round_robin_arbiter #(
      .NUM_REQ(NUM_REQ)
  ) round_robin_arbiter_dut (
      .clk_i(clk_i),
      .arst_ni(arst_ni),
      .allow_req_i(allow_req_i),
      .req_i(req_i),
      .gnt_addr_o(gnt_addr_o),
      .gnt_addr_valid_o(gnt_addr_valid_o)
  );

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    repeat (3) @(posedge clk_i);
    arst_ni <= 1;
    #1000;
    $finish;
  end

  always #5 clk_i = !clk_i;

  always @(posedge clk_i) begin
    allow_req_i <= ($urandom_range(0, 9) > 1);
    req_i       <= $urandom;
  end

endmodule
