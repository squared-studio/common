module tb_mem_bank;
  initial begin
    $dumpfile("raw.vcd");
    $dumpvars;
    $display("%c[7;38m################################# TEST STARTED #################################%c[0m", 27, 27);
  end
  final begin
    $display("%c[7;38m################################## TEST ENDED ##################################%c[0m", 27, 27);
  end

  localparam ADDR_WIDTH = 12;
  localparam DATA_SIZE  = 2;
  localparam DATA_BYTES = 2**DATA_SIZE;
  localparam DATA_WIDTH = 8*DATA_BYTES;

  int pass;
  int fail;
  int cnt;

  logic                  clk_i;
  logic [ADDR_WIDTH-1:0] addr ;
  logic [DATA_WIDTH-1:0] wdata;
  logic [DATA_BYTES-1:0] wstrb;
  logic [DATA_WIDTH-1:0] rdata;

  mem_bank #(
    .ADDR_WIDTH ( ADDR_WIDTH ),
    .DATA_SIZE  ( DATA_SIZE  )
  ) u_mem_bank (
    .clk_i ( clk_i ),
    .addr  ( addr  ),
    .wdata ( wdata ),
    .wstrb ( wstrb ),
    .rdata ( rdata )
  );

  task start_clock ();
    fork
      forever begin
        clk_i = 1; #5;
        clk_i = 0; #5;
      end
    join_none
    repeat (2) @ (posedge clk_i);
  endtask

  initial begin
    start_clock();

    for (int i = 0; i < 10; i++) begin
      @ (posedge clk_i);
      addr  <= i;
      wdata <= i;
      wstrb <= '1;
    end

    @ (posedge clk_i);
    wstrb <= '0;

    repeat(5) @ (posedge clk_i);

    $finish();
  end
  
endmodule