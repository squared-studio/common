////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : ...
//    DESCRIPTION : ...
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module tb_mem_bank;
  initial begin
    $dumpfile("raw.vcd");
    $dumpvars;
    $display(
        "%c[7;38m################################# TEST STARTED #################################%c[0m"
        , 27, 27);
  end
  final begin
    $display(
        "%c[7;38m################################## TEST ENDED ##################################%c[0m"
        , 27, 27);
  end

  localparam int AddrWidth = 12;
  localparam int DataSize = 2;
  localparam int DataBytes = 2 ** DataSize;
  localparam int DataWidth = 8 * DataBytes;

  int                   pass;
  int                   fail;
  int                   cnt;

  logic                 clk_i;
  logic [AddrWidth-1:0] addr_i;
  logic [DataWidth-1:0] wdata_i;
  logic [DataBytes-1:0] wstrb_i;
  logic [DataWidth-1:0] rdata_o;

  mem_bank #(
      .AddrWidth(AddrWidth),
      .DataSize (DataSize)
  ) u_mem_bank (
      .clk_i  (clk_i),
      .cs_i   ('1),
      .addr_i (addr_i),
      .wdata_i(wdata_i),
      .wstrb_i(wstrb_i),
      .rdata_o(rdata_o)
  );

  task static start_clock();
    fork
      forever begin
        clk_i = 1;
        #5;
        clk_i = 0;
        #5;
      end
    join_none
    repeat (2) @(posedge clk_i);
  endtask

  initial begin
    start_clock();

    for (int i = 0; i < 10; i++) begin
      @(posedge clk_i);
      addr_i  <= i;
      wdata_i <= i;
      wstrb_i <= '1;
    end

    for (int i = 10; i < 20; i++) begin
      @(posedge clk_i);
      addr_i  <= i;
      wdata_i <= i;
      wstrb_i <= $urandom();
    end

    @(posedge clk_i);
    wstrb_i <= '0;

    repeat (5) @(posedge clk_i);

    $finish();
  end

endmodule
