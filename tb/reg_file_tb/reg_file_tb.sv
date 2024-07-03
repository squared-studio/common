/*
Author : Foez Ahmed (foez.official@gmail.com)
*/

module reg_file_tb;

  `define ENABLE_DUMPFILE

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-IMPORTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // bring in the testbench essentials functions and macros
  `include "vip/tb_ess.sv"

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-LOCALPARAMS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  localparam int NumRs = 1;
  localparam bit ZeroReg = 1;
  localparam int NumReg = 16;
  localparam int RegWidth = 32;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // generates static task start_clk_i with tHigh:4ns tLow:6ns
  `CREATE_CLK(clk_i, 5ns, 5ns)

  logic                                          arst_ni = '1;
  logic [$clog2(NumReg)-1:0]                     rd_addr_i = '0;
  logic [      RegWidth-1:0]                     rd_data_i = '0;
  logic                                          rd_en_i = '0;
  logic [         NumRs-1:0][$clog2(NumReg)-1:0] rs_addr_i = '0;
  logic [         NumRs-1:0][      RegWidth-1:0] rs_data_o;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-VARIABLES
  //////////////////////////////////////////////////////////////////////////////////////////////////

  int                                            pass;
  int                                            fail;

  logic [      RegWidth-1:0]                     ref_mem        [NumReg];

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  reg_file #(
      .NUM_RS   (NumRs   ),
      .ZERO_REG (ZeroReg ),
      .NUM_REG  (NumReg  ),
      .REG_WIDTH(RegWidth)
  ) u_reg_file (
      .clk_i,
      .arst_ni,
      .rd_addr_i,
      .rd_data_i,
      .rd_en_i,
      .rs_addr_i,
      .rs_data_o
  );

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-METHODS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  task static apply_reset();
    #100ns;
    arst_ni <= 0;
    foreach (ref_mem[i]) ref_mem[i] <= '0;
    #100ns;
    arst_ni <= 1;
    #100ns;
  endtask

  // generate random transactions
  task static start_rand_dvr();
    fork
      forever begin
        rd_en_i   <= $urandom;
        rd_data_i <= $urandom;
        rd_addr_i <= $urandom & 'h1f;
        for (int i = 0; i < NumRs; i++) begin
          rs_addr_i[i] <= $urandom & 'h1f;
          rs_data_o[i] <= $urandom;
        end
        @(posedge clk_i);
      end
    join_none
  endtask

  // monitor and check
  task static start_checking();
    fork
      forever begin
        @(posedge clk_i);
        for (int i = 0; i < NumRs; i++) begin
          if (rs_data_o[i] == ref_mem[rs_addr_i[i]]) begin
            pass++;
            $write("\033[1;32m");
          end else begin
            fail++;
            $write("\033[1;31m");
          end
          $display("PORT%0d REG%0d GOT_DATA:0x%h EXP_DATA:0x%h [%0t]\033[0m", i, rs_addr_i[i],
                   rs_data_o[i], ref_mem[rs_addr_i[i]], $realtime);
        end
        if (rd_en_i && (rd_addr_i != '0)) begin
          ref_mem[rd_addr_i] = rd_data_i;
          $display("\033[1;36mWRITE REG%0d DATA:0x%h [%0t]\033[0m", rd_addr_i, rd_data_i,
                   $realtime);
        end
      end
    join_none
  endtask

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-PROCEDURALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  initial begin  // main initial

    apply_reset();
    start_clk_i();

    @(posedge clk_i);

    // Data flow checking
    start_rand_dvr();
    start_checking();
    repeat (1000) @(posedge clk_i);
    result_print(!fail, $sformatf("frontdoor data flow %0d/%0d", pass, pass + fail));

    $finish;

  end

endmodule
