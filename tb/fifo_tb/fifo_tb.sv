// Author : Foez Ahmed (foez.official@gmail.com)
// This file is part of squared-studio:common
// Copyright (c) 2024 squared-studio
// Licensed under the MIT License
// See LICENSE file in the project root for full license information

module fifo_tb;

  `define ENABLE_DUMPFILE

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-IMPORTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // bring in the testbench essentials functions and macros
  `include "vip/tb_ess.sv"

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-LOCALPARAMS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  localparam bit Pipelined = 0;
  localparam int ElemWidth = 4;
  localparam int FifoSize = 3;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // generates static task start_clk_i with tHigh:3 tLow:7
  `CREATE_CLK(clk_i, 3, 7)
  logic                 arst_ni;
  logic [ElemWidth-1:0] elem_in_i;
  logic                 elem_in_valid_i;
  logic                 elem_in_ready_o;
  logic [ElemWidth-1:0] elem_out_o;
  logic                 elem_out_valid_o;
  logic                 elem_out_ready_i;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-VARIABLES
  //////////////////////////////////////////////////////////////////////////////////////////////////

  int                   err;
  int                   in_cnt;
  int                   out_cnt;

  logic [ElemWidth-1:0] elem_queue       [$];

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  fifo #(
      .PIPELINED (Pipelined),
      .ELEM_WIDTH(ElemWidth),
      .FIFO_SIZE (FifoSize)
  ) u_fifo (
      .clk_i           (clk_i),
      .arst_ni         (arst_ni),
      .elem_in_i       (elem_in_i),
      .elem_in_valid_i (elem_in_valid_i),
      .elem_in_ready_o (elem_in_ready_o),
      .elem_out_o      (elem_out_o),
      .elem_out_valid_o(elem_out_valid_o),
      .elem_out_ready_i(elem_out_ready_i)
  );

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-METHODS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  task static apply_reset();
    elem_queue.delete();
    err = 0;
    in_cnt = 0;
    out_cnt = 0;
    clk_i = 1;
    elem_in_i = 0;
    elem_in_valid_i = 0;
    elem_out_ready_i = 0;
    #5;
    arst_ni = 0;
    #5;
    arst_ni = 1;
    #5;
  endtask

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-PROCEDURALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  always @(posedge clk_i) begin
    if (elem_in_valid_i && elem_in_ready_o) begin
      in_cnt++;
      elem_queue.push_back(elem_in_i);
    end
    if (elem_out_valid_o && elem_out_ready_i) begin
      out_cnt++;
      if (elem_queue.pop_front() !== elem_out_o) begin
        err++;
      end
    end
  end

  initial begin
    bit prev_elem_in_valid;
    bit prev_elem_in_ready;
    bit prev_elem_out_valid;
    bit prev_elem_out_ready;

    apply_reset();
    start_clk_i();

    elem_in_valid_i  <= '1;
    elem_out_ready_i <= '0;
    for (int i = 0; i < (2 ** FifoSize); i++) begin
      @(posedge clk_i);
      prev_elem_in_ready = elem_in_ready_o;
    end

    @(posedge clk_i);
    prev_elem_in_ready = elem_in_ready_o;

    apply_reset();

    result_print(elem_in_ready_o & ~prev_elem_in_ready, "sync reset");

    arst_ni <= '0;
    @(posedge clk_i);
    arst_ni <= '1;
    @(posedge clk_i);

    elem_in_valid_i <= '1;
    for (int i = 0; i < (2 ** FifoSize); i++) begin
      prev_elem_in_ready = elem_in_ready_o;
      @(posedge clk_i);
    end

    @(posedge clk_i);
    elem_in_valid_i <= '0;

    result_print(~elem_in_ready_o & prev_elem_in_ready, "elem_in_ready_o LOW at exact full");

    elem_out_ready_i <= '1;
    for (int i = 0; i < (2 ** FifoSize); i++) begin
      prev_elem_out_valid = elem_out_valid_o;
      @(posedge clk_i);
    end

    @(posedge clk_i);
    elem_out_ready_i <= '0;

    result_print(~elem_out_valid_o & prev_elem_out_valid, "elem_out_valid_o LOW at exact empty");

    repeat (2) @(posedge clk_i);

    elem_in_valid_i  <= 0;
    elem_out_ready_i <= 0;

    @(posedge clk_i);
    prev_elem_in_valid  = elem_in_valid_i;
    prev_elem_in_ready  = elem_in_ready_o;
    prev_elem_out_valid = elem_out_valid_o;
    prev_elem_out_ready = elem_out_ready_i;
    elem_in_valid_i  <= '1;
    elem_out_ready_i <= '1;
    @(posedge clk_i);

    result_print(
        ~prev_elem_in_valid
            & prev_elem_in_ready
            & ~prev_elem_out_valid
            & ~prev_elem_out_ready
            & elem_in_valid_i
            & elem_in_ready_o
            & elem_out_valid_o
            & elem_out_ready_i
        , "direct bypass when EMPTY");

    elem_out_ready_i <= 0;

    elem_in_valid_i  <= 1;
    do @(posedge clk_i); while (elem_in_ready_o);
    elem_in_valid_i <= 0;

    @(posedge clk_i);
    prev_elem_in_valid  = elem_in_valid_i;
    prev_elem_in_ready  = elem_in_ready_o;
    prev_elem_out_valid = elem_out_valid_o;
    prev_elem_out_ready = elem_out_ready_i;
    elem_in_valid_i  <= '1;
    elem_out_ready_i <= '1;
    @(posedge clk_i);

    result_print(
        ~prev_elem_in_valid
            & ~prev_elem_in_ready
            & prev_elem_out_valid
            & ~prev_elem_out_ready
            & elem_in_valid_i
            & elem_in_ready_o
            & elem_out_valid_o
            & elem_out_ready_i
        , "both side handshake when FULL");

    elem_queue.delete();
    elem_in_valid_i  <= 0;
    elem_out_ready_i <= 0;
    err = 0;
    in_cnt = 0;
    out_cnt = 0;
    arst_ni <= 0;
    @(posedge clk_i);
    arst_ni <= 1;
    @(posedge clk_i);

    // overflow
    while (out_cnt < 100) begin
      elem_in_i        <= $urandom;
      elem_in_valid_i  <= ($urandom_range(0, 9) > 0);
      elem_out_ready_i <= ($urandom_range(0, 9) > 8);
      @(posedge clk_i);
    end

    // underflow
    while (out_cnt < 100) begin
      elem_in_i        <= $urandom;
      elem_in_valid_i  <= ($urandom_range(0, 9) > 8);
      elem_out_ready_i <= ($urandom_range(0, 9) > 0);
      @(posedge clk_i);
    end

    // normal
    while (in_cnt < 200) begin
      elem_in_i        <= $urandom;
      elem_in_valid_i  <= $urandom_range(0, 1);
      elem_out_ready_i <= $urandom_range(0, 1);
      @(posedge clk_i);
    end

    elem_in_valid_i  <= 0;
    elem_out_ready_i <= 1;
    while (out_cnt < 200) begin
      @(posedge clk_i);
    end
    elem_out_ready_i <= 0;

    result_print(err == 0, "elemflow");

    $finish();
  end

endmodule
