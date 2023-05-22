////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    Author : Foez Ahmed (foez.official@gmail.com)
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module round_robin_arbiter_tb;

  // Parameters
  localparam int Clog2NumReq = 4;
  localparam int NumReq = (2 ** Clog2NumReq);

  // Ports
  logic clk_i = 1;
  logic arst_ni = 1;
  logic [NumReq-1:0] req_i;
  logic [NumReq-1:0] gnt_o;

  round_robin_arbiter #(
      .Clog2NumReq(Clog2NumReq)
  ) round_robin_arbiter_dut (
      .clk_i  (clk_i),
      .arst_ni(arst_ni),
      .req_i  (req_i),
      .gnt_o  (gnt_o)
  );

  initial begin
    $dumpfile("raw.vcd");
    $dumpvars();
    req_i <= '0;
    arst_ni = 1;
    #10;
    arst_ni = 0;
    #10;
    arst_ni = 1;
    #10;
    req_i <= 'h5a5a;
    repeat (50) begin
      @(posedge clk_i);
    end
    $finish;
  end

  always #5 clk_i = !clk_i;

endmodule
