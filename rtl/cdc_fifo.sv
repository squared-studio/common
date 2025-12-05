/*
The `cdc_fifo` module is a clock domain crossing (CDC) FIFO. It takes an input element (`elem_in_i`)
under one clock domain (`elem_in_clk_i`) and outputs the element (`elem_out_o`) under another clock
domain (`elem_out_clk_i`).
The module uses a FIFO to transfer data across clock domains. The FIFO is written to under the input
clock domain and read from under the output clock domain. The write and read pointers are passed
across clock domains using gray code to prevent metastability issues. The FIFO is ready to accept
input when the write pointer does not equal the read pointer. The output is valid when the write
pointer equals the read pointer.
Author : Foez Ahmed (foez.official@gmail.com)
<br>This file is part of squared-studio:common
<br>Copyright (c) 2025 squared-studio
<br>Licensed under the MIT License
<br>See LICENSE file in the project root for full license information
*/

module cdc_fifo #(
    parameter int ELEM_WIDTH = 8,  // width of the elements in the FIFO
    parameter int FIFO_SIZE  = 2   // size of the FIFO to the power of 2
) (
    // Asynchronous active low reset input
    input logic arst_ni,

    // Input element. This is a `ELEM_WIDTH`-bit data that is to be written into the FIFO
    input  logic [ELEM_WIDTH-1:0] elem_in_i,
    // Input clock
    input  logic                  elem_in_clk_i,
    // Input valid signal. When high, indicates that the input element is valid and can be written
    // into the FIFO
    input  logic                  elem_in_valid_i,
    // Input ready signal. When high, indicates that the FIFO is ready to accept the input element
    output logic                  elem_in_ready_o,
    // Element Count Input Clock Domain
    output logic [$clog2(2**FIFO_SIZE)-1:0] elem_in_count_o,

    // Output element. This is a `ELEM_WIDTH`-bit data that is read from the FIFO
    output logic [ELEM_WIDTH-1:0] elem_out_o,
    // Output clock
    input  logic                  elem_out_clk_i,
    // Output valid signal. When high, indicates that the output element is valid and can be read
    output logic                  elem_out_valid_o,
    // Output ready signal. When high, indicates that the output element can be read from the FIFO
    input  logic                  elem_out_ready_i,
    // Element Count Output Clock Domain
    output logic [$clog2(2**FIFO_SIZE)-1:0] elem_out_count_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [FIFO_SIZE:0] wr_ptr_pass;  // Passing write pointer gray across clock domain
  logic [FIFO_SIZE:0] rd_ptr_pass;  // Passing read pointer gray across clock domain

  logic hsi;  // input handshake
  logic hso;  // output handshake

  logic [FIFO_SIZE:0] wr_addr;  // write address
  logic [FIFO_SIZE:0] rd_addr;  // read address

  logic [FIFO_SIZE:0] wr_addr_;  // write address on other clock
  logic [FIFO_SIZE:0] rd_addr_;  // read address on other clock

  logic [FIFO_SIZE:0] wr_addr_p1;  // write address +1
  logic [FIFO_SIZE:0] rd_addr_p1;  // read address +1

  logic [FIFO_SIZE:0] wpgi;  // write pointer gray in to the reg
  logic [FIFO_SIZE:0] rpgi;  // read pointer gray in to the reg

  logic [FIFO_SIZE:0] wpgo;  // write pointer gray out from the reg
  logic [FIFO_SIZE:0] rpgo;  // read pointer gray out from the reg

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign hsi = elem_in_valid_i & elem_in_ready_o;
  assign hso = elem_out_valid_o & elem_out_ready_i;

  assign wr_addr_p1 = wr_addr + 1;
  assign rd_addr_p1 = rd_addr + 1;

  if (FIFO_SIZE > 0) begin : g_elem_in_ready_o
    assign elem_in_ready_o = arst_ni & !(
                                (wr_addr[FIFO_SIZE] != rd_addr_[FIFO_SIZE])
                                &&
                                (wr_addr[FIFO_SIZE-1:0] == rd_addr_[FIFO_SIZE-1:0])
                              );
  end else begin : g_elem_in_ready_o
    assign elem_in_ready_o = arst_ni & (wr_addr_ == rd_addr);
  end

  assign elem_out_valid_o = (wr_addr_ != rd_addr);

  assign elem_in_count_o  = wr_addr[FIFO_SIZE-1:0] - rd_addr_[FIFO_SIZE-1:0];
  assign elem_out_count_o = wr_addr_[FIFO_SIZE-1:0] - rd_addr[FIFO_SIZE-1:0];

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  gray_to_bin #(
      .DATA_WIDTH(FIFO_SIZE + 1)
  ) g2b_wi (
      .data_in_i (wr_ptr_pass),
      .data_out_o(wr_addr)
  );

  gray_to_bin #(
      .DATA_WIDTH(FIFO_SIZE + 1)
  ) g2b_ri (
      .data_in_i (rpgo),
      .data_out_o(rd_addr_)
  );

  gray_to_bin #(
      .DATA_WIDTH(FIFO_SIZE + 1)
  ) g2b_wo (
      .data_in_i (wpgo),
      .data_out_o(wr_addr_)
  );

  gray_to_bin #(
      .DATA_WIDTH(FIFO_SIZE + 1)
  ) g2b_ro (
      .data_in_i (rd_ptr_pass),
      .data_out_o(rd_addr)
  );

  bin_to_gray #(
      .DATA_WIDTH(FIFO_SIZE + 1)
  ) b2g_w (
      .data_in_i (wr_addr_p1),
      .data_out_o(wpgi)
  );

  bin_to_gray #(
      .DATA_WIDTH(FIFO_SIZE + 1)
  ) b2g_r (
      .data_in_i (rd_addr_p1),
      .data_out_o(rpgi)
  );

  register #(
      .ELEM_WIDTH (FIFO_SIZE + 1),
      .RESET_VALUE('0)
  ) wr_ptr_ic (
      .clk_i  (elem_in_clk_i),
      .arst_ni(arst_ni),
      .en_i   (hsi),
      .d_i    (wpgi),
      .q_o    (wr_ptr_pass)
  );

  register_dual_flop #(
      .ELEM_WIDTH(FIFO_SIZE + 1),
      .RESET_VALUE('0),
      .FIRST_FF_EDGE_POSEDGED(0),
      .LAST_FF_EDGE_POSEDGED(1)
  ) rd_ptr_ic (
      .clk_i  (elem_in_clk_i),
      .arst_ni(arst_ni),
      .en_i   ('1),
      .d_i    (rd_ptr_pass),
      .q_o    (rpgo)
  );

  register_dual_flop #(
      .ELEM_WIDTH(FIFO_SIZE + 1),
      .RESET_VALUE('0),
      .FIRST_FF_EDGE_POSEDGED(0),
      .LAST_FF_EDGE_POSEDGED(1)
  ) wr_ptr_oc (
      .clk_i  (elem_out_clk_i),
      .arst_ni(arst_ni),
      .en_i   ('1),
      .d_i    (wr_ptr_pass),
      .q_o    (wpgo)
  );

  register #(
      .ELEM_WIDTH (FIFO_SIZE + 1),
      .RESET_VALUE('0)
  ) rd_ptr_oc (
      .clk_i  (elem_out_clk_i),
      .arst_ni(arst_ni),
      .en_i   (hso),
      .d_i    (rpgi),
      .q_o    (rd_ptr_pass)
  );

  if (FIFO_SIZE > 0) begin : g_mem
    mem #(
        .ELEM_WIDTH(ELEM_WIDTH),
        .DEPTH(2 ** FIFO_SIZE)
    ) u_mem (
        .clk_i  (elem_in_clk_i),
        .arst_ni(arst_ni),
        .we_i   (hsi),
        .waddr_i(wr_addr[FIFO_SIZE-1:0]),
        .wdata_i(elem_in_i),
        .raddr_i(rd_addr[FIFO_SIZE-1:0]),
        .rdata_o(elem_out_o)
    );
  end else begin : g_mem
    register #(
        .ELEM_WIDTH (ELEM_WIDTH),
        .RESET_VALUE('0)
    ) u_mem (
        .clk_i  (elem_in_clk_i),
        .arst_ni(arst_ni),
        .en_i   (hsi),
        .d_i    (elem_in_i),
        .q_o    (elem_out_o)
    );
  end

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-INITIAL CHECKS
  //////////////////////////////////////////////////////////////////////////////////////////////////

`ifdef SIMULATION
  initial begin
    if (FIFO_SIZE > 3) begin
      $display("\033[7;31m%m FIFO_SIZE=%0d is quite big\033[0m", FIFO_SIZE);
    end
  end
`endif  // SIMULATION

endmodule
