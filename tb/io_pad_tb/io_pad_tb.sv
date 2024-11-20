/*
TB for IO pad
Author : Foez Ahmed (foez.official@gmail.com)
<br>This file is part of squared-studio:common
<br>Copyright (c) 2024 squared-studio
<br>Licensed under the MIT License
<br>See LICENSE file in the project root for full license information
*/

module io_pad_tb;

  //`define ENABLE_DUMPFILE

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-IMPORTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // bring in the testbench essentials functions and macros
  `include "vip/tb_ess.sv"

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // generates static task start_clk_i with tHigh:4ns tLow:6ns
  `CREATE_CLK(clk_i, 5ns, 5ns)

  reg  pull_i = '0;
  reg  wdata_i = '0;
  reg  wen_i = '0;
  wire rdata_o;
  wire pin_io;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-VARIABLES
  //////////////////////////////////////////////////////////////////////////////////////////////////

  bit  pin;
  bit  pin_drv;

  int  rdata_o_err = 0;
  int  pin_io_err = 0;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign pin_io = ((!wen_i) & pin_drv) ? pin : 'z;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  io_pad #() u_io_pad (
      .pull_i (pull_i),
      .wdata_i(wdata_i),
      .wen_i  (wen_i),
      .rdata_o(rdata_o),
      .pin_io (pin_io)
  );

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-PROCEDURALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // Main test sequence
  initial begin

    // Start the clock
    start_clk_i();

    // Fork-join to run multiple threads in parallel
    fork

      // Wait for two clock cycles before starting the checks
      repeat (2) @(posedge clk_i);

      begin
        fork

          // Check the read data signal in every clock cycle
          forever begin
            @(posedge clk_i);
            if (pin_io === 'z) begin
              if (rdata_o !== 'x) rdata_o_err++;
            end else begin
              if (rdata_o !== pin_io) rdata_o_err++;
            end
          end

          // Check the IO pin signal in every clock cycle
          forever begin
            @(posedge clk_i);
            if (wen_i) begin
              if (pin_io !== wdata_i) pin_io_err++;
            end else begin
              if (pin_drv) begin
                if (pin_io !== pin) pin_io_err++;
              end else if (pull_i) begin
                if (pin_io !== wdata_i) pin_io_err++;
              end else begin
                if (pin_io !== 'z) pin_io_err++;
              end
            end
          end

        join
      end

    join_none

    // Generate random inputs for 1001 clock cycles
    repeat (1001) begin
      @(posedge clk_i);
      pull_i  <= $urandom;
      wdata_i <= $urandom;
      wen_i   <= $urandom;
      pin     <= $urandom;
      pin_drv <= $urandom;
    end

    // Print the results
    result_print(!pin_io_err, "pin_io OK");
    result_print(!rdata_o_err, "rdata_o OK");

    // Finish the simulation
    $finish;

  end

endmodule
