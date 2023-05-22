////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    Author      : Foez Ahmed
//
//    Email       : foez.official@gmail.com
//
//    module      : ...
//
//    Description : ...
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module tb_apb_mem;

  initial begin
    $dumpfile("raw.vcd");
    $dumpvars;
    $display(
        "%c[7;38m############################## TEST STARTED ##############################%c[0m",
        27, 27);
  end
  final begin
    $display(
        "%c[7;38m############################### TEST ENDED ###############################%c[0m",
        27, 27);
  end

  localparam int AddrWidth = 8;
  localparam int DataWidth = 8;

  logic                 clk_i;
  logic                 arst_ni;
  logic [          3:0] psel_i;
  logic                 penable_i;
  logic [AddrWidth-1:0] paddr_i;
  logic                 pwrite_i;
  logic [DataWidth-1:0] pwdata_i;
  wire  [DataWidth-1:0] prdata_o;
  wire                  pready_o;

  for (genvar i = 0; i < 4; i++) begin : g_slaves
    apb_mem #(
        .AddrWidth(AddrWidth),
        .DataWidth(DataWidth)
    ) u_apb_mem (
        .clk_i(clk_i),
        .arst_ni(arst_ni),
        .psel_i(psel_i[i]),
        .penable_i(penable_i),
        .paddr_i(paddr_i),
        .pwrite_i(pwrite_i),
        .pwdata_i(pwdata_i),
        .prdata_o(prdata_o),
        .pready_o(pready_o)
    );
  end




  task static apply_reset();
    arst_ni = '1;
    clk_i   = '1;
    #100;
    arst_ni = '0;
    psel_i = 0;
    penable_i = 0;
    paddr_i = 0;
    pwrite_i = 0;
    pwdata_i = 0;
    #100;
    arst_ni = '1;
    #100;
  endtask

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

  task static just_write(byte sel, byte addr, byte data);
    @(posedge clk_i);
    paddr_i     <= addr;
    pwrite_i    <= '1;
    pwdata_i    <= data;
    psel_i[sel] <= '1;
    penable_i   <= '0;

    @(posedge clk_i);
    penable_i <= '1;

    do @(posedge clk_i); while (pready_o !== '1);

    @(posedge clk_i);
    penable_i <= '0;

    @(posedge clk_i);
    psel_i <= '0;
  endtask

  task static just_read(byte sel, byte addr);
    @(posedge clk_i);
    paddr_i     <= addr;
    pwrite_i    <= '0;
    psel_i[sel] <= '1;
    penable_i   <= '0;

    @(posedge clk_i);
    penable_i <= '1;

    do @(posedge clk_i); while (pready_o !== '1);

    @(posedge clk_i);
    penable_i <= '0;

    @(posedge clk_i);
    psel_i <= '0;
  endtask

  initial begin
    apply_reset();
    start_clock();

    just_write(0, 0, 'hF0);
    just_write(1, 0, 'he2);

    just_read(0, 0);
    just_read(1, 0);

    repeat (20) @(posedge clk_i);
    $finish;
  end

endmodule
