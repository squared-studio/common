// ### Author : Foez Ahmed (foez.official@gmail.com)

module fixed_priority_arbiter_tb;

  // Parameters

  localparam int NumReq = 4;

  // Ports
  reg clk_i;
  reg [NumReq-1:0] req_i;
  wire [NumReq-1:0] gnt_o;

  fixed_priority_arbiter #(
      .NumReq(NumReq)
  ) fixed_priority_arbiter_dut (
      .req_i(req_i),
      .gnt_o(gnt_o)
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
          if (req_i[i] == '1) begin
            cont = 0;
            if (gnt_o == (1 << i)) begin
              $write("PASSED: ");
              pass++;
            end else begin
              $write("FAILED: ");
              fail++;
            end
            $display("0b%b 0b%b", req_i, gnt_o);
          end
        end

      end

      begin
        for (int i = 0; i < (2 ** NumReq); i++) begin
          @(posedge clk_i);
          req_i <= i;
        end
        @(posedge clk_i);
      end

    join_any

    $display("%0d", pass, "/%0d", pass + fail, " PASSED");
    $finish;
  end

endmodule
