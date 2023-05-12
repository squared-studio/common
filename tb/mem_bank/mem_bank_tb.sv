////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : mem_bank_tb
//    DESCRIPTION : A testbench for memory bank verification
//
////////////////////////////////////////////////////////////////////////////////////////////////////

//`define DEBUG

module mem_bank_tb;

  //`define ENABLE_DUMPFILE

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // IMPORTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // bring in the testbench essentials functions and macros
  `include "tb_essentials.sv"

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // LOCALPARAMS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  localparam int AddrWidth = 9;
  localparam int DataSize = 2;
  localparam int DataBytes = (2 ** DataSize);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // generates static task start_clk_i with tHigh:3 tLow:7
  `CREATE_CLK(clk_i, 3, 7)

  logic                      cs_i = 0;
  logic [AddrWidth-1:0]      addr_i;
  logic [DataBytes-1:0][7:0] wdata_i;
  logic [DataBytes-1:0]      wstrb_i;
  logic [DataBytes-1:0][7:0] rdata_o;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // VARIABLES
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [          7:0]      ref_mem     [2**AddrWidth];

  int                        byte_passed;
  int                        byte_failed;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  always @(posedge clk_i) begin
    if (cs_i) begin
      foreach (rdata_o[i]) begin
        if (rdata_o[i] === ref_mem[({addr_i[AddrWidth-1:DataSize], {DataSize{1'b0}}})+i]) begin
          byte_passed++;
        end else begin
          byte_failed++;
        end
      end
`ifdef DEBUG
      $display("ADDR:0x%h DATA:0x%h", ({addr_i[AddrWidth-1:DataSize], {DataSize{1'b0}}}), rdata_o);
`endif  // DEBUG
    end
  end

  always @(posedge clk_i) begin
    if (cs_i) begin
`ifdef DEBUG
      $display("ADDR:0x%h DATA:0x%h STRB:0b%b", ({addr_i[AddrWidth-1:DataSize], {DataSize{1'b0}}}),
               wdata_i, wstrb_i);
`endif  // DEBUG
      foreach (wstrb_i[i]) begin
        if (wstrb_i[i]) ref_mem[({addr_i[AddrWidth-1:DataSize], {DataSize{1'b0}}})+i] <= wdata_i[i];
      end
    end
  end

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  mem_bank #(
      .AddrWidth(AddrWidth),
      .DataSize (DataSize)
  ) mem_bank_dut (
      .clk_i  (clk_i),
      .cs_i   (cs_i),
      .addr_i (addr_i),
      .wdata_i(wdata_i),
      .wstrb_i(wstrb_i),
      .rdata_o(rdata_o)
  );

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // METHODS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  task static mem_write(
    input bit [AddrWidth-1:0]      addr,
    input bit [DataBytes-1:0][7:0] data,
    input bit [DataBytes-1:0]      strb
  );
    cs_i    <= '1;
    addr_i  <= addr;
    wdata_i <= data;
    wstrb_i <= strb;
    @(posedge clk_i);
    cs_i    <= '0;
  endtask

  task static mem_read(
    input bit [AddrWidth-1:0] addr
  );
    cs_i    <= '1;
    addr_i  <= addr;
    wstrb_i <= '0;
    @(posedge clk_i);
    cs_i    <= '0;
  endtask

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // PROCEDURALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  initial begin
    start_clk_i();

    //mem_write (0, $urandom, '1);
    //mem_read  (0);

    mem_write(0, 'h12345678, '1);
    mem_read(0);

    cs_i    <= '0;
    addr_i  <= '0;
    wdata_i <= '1;
    wstrb_i <= '1;
    @(posedge clk_i);
    cs_i    <= '0;
    mem_read(0);

    @(posedge clk_i);
    result_print(!byte_failed, "Chip Select");
    byte_passed = 0;
    byte_failed = 0;

    mem_write(0, 'h87654321, '1);
    mem_write(0, 'h98765432, '0);
    mem_read(0);

    @(posedge clk_i);
    result_print(!byte_failed, "Strobe");
    byte_passed = 0;
    byte_failed = 0;

    repeat (10000) mem_write($urandom, $urandom, $urandom);

    @(posedge clk_i);
    result_print(!byte_failed, "Data Integrity");

    $finish;

  end

endmodule
