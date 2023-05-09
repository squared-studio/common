////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : ...
//    DESCRIPTION : ...
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module fixed_priority_arbiter_tb;

  // Parameters

  localparam int NumReq = 4;

  // Ports
  reg clk_i;
  reg [NumReq-1:0] req;
  wire [NumReq-1:0] gnt;

  fixed_priority_arbiter #(
      .NumReq(NumReq)
  ) fixed_priority_arbiter_dut (
      .req(req),
      .gnt(gnt)
  );

  initial begin
    static int pass;
    static int fail;

    fork
      forever begin
        clk_i = 1;
        #5;
        clk_i = 0;
        #5;
      end
    join_none

    fork

      forever
      @(negedge clk_i) begin
        bit cont;
        cont = 1;
        for (int i = 0; (i < NumReq) && cont; i++) begin
          if (req[i] == '1) begin
            cont = 0;
            if (gnt == (1 << i)) begin
              $write("PASSED: ");
              pass++;
            end else begin
              $write("FAILED: ");
              fail++;
            end
            //$display("%h %h", req, gnt);
          end
        end

      end

      begin
        for (int i = 0; i < (2 ** NumReq); i++) begin
          @(posedge clk_i);
          req <= i;
        end
        @(posedge clk_i);
      end

    join_any

    $display("%0d", pass, "/%0d", pass + fail, " PASSED");
    $finish;
  end

endmodule
