// Simple FIFO
// ### Author : Foez Ahmed (foez.official@gmail.com)

module fifo #(
    parameter bit PIPELINED  = 1,  // Width of each element
    parameter int ELEM_WIDTH = 8,  // Width of each element
    parameter int FIFO_SIZE  = 4   // Number of elements that can be stored in the FIFO
) (
    input logic clk_i,   // Input clock
    input logic arst_ni, // Asynchronous reset

    input  logic [ELEM_WIDTH-1:0] elem_in_i,        // Input element
    input  logic                  elem_in_valid_i,  // Input valid
    output logic                  elem_in_ready_o,  // Input ready

    output logic [ELEM_WIDTH-1:0] elem_out_o,        // Output element
    output logic                  elem_out_valid_o,  // Output valid
    input  logic                  elem_out_ready_i   // Output ready
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [FIFO_SIZE:0] wr_ptr;  // Write pointer
  logic [FIFO_SIZE:0] rd_ptr;  // Read pointer

  logic [FIFO_SIZE:0] wr_ptr_next;  // Write pointer
  logic [FIFO_SIZE:0] rd_ptr_next;  // Read pointer

  logic hsi;  // input handshake
  logic hso;  // output handshake

  logic msb_eq;  // MSB equal
  logic nmsb_eq;  // non-MSB equal

  logic empty;  // fifo empty
  logic full;  // fifo full

  logic [ELEM_WIDTH-1:0] elem_out;  // element out

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign hsi = elem_in_valid_i & elem_in_ready_o;
  assign hso = elem_out_valid_o & elem_out_ready_i;

  assign wr_ptr_next = wr_ptr + 1;
  assign rd_ptr_next = rd_ptr + 1;

  assign msb_eq = (wr_ptr[FIFO_SIZE] == rd_ptr[FIFO_SIZE]);
  assign nmsb_eq = (wr_ptr[FIFO_SIZE-1:0] == rd_ptr[FIFO_SIZE-1:0]);

  assign empty = msb_eq & nmsb_eq;
  assign full = !msb_eq & nmsb_eq;

  assign elem_in_ready_o = full ? elem_out_ready_i : '1;

  if (PIPELINED) begin : g_pipelined
    assign elem_out_valid_o = ~empty;
    assign elem_out_o = elem_out;
  end else begin : g_pass_through
    assign elem_out_valid_o = empty ? elem_in_valid_i : '1;
    assign elem_out_o       = empty ? elem_in_i : elem_out;
  end

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  register #(
      .ELEM_WIDTH (FIFO_SIZE + 1),
      .RESET_VALUE('0)
  ) wr_ptr_reg (
      .clk_i  (clk_i),
      .arst_ni(arst_ni),
      .en_i   (hsi),
      .d_i    (wr_ptr_next),
      .q_o    (wr_ptr)
  );

  register #(
      .ELEM_WIDTH (FIFO_SIZE + 1),
      .RESET_VALUE('0)
  ) rd_ptr_reg (
      .clk_i  (clk_i),
      .arst_ni(arst_ni),
      .en_i   (hso),
      .d_i    (rd_ptr_next),
      .q_o    (rd_ptr)
  );

  if (FIFO_SIZE > 0) begin : g_mem
    mem #(
        .ELEM_WIDTH(ELEM_WIDTH),
        .DEPTH(2 ** FIFO_SIZE)
    ) u_mem (
        .clk_i  (clk_i),
        .arst_ni(arst_ni),
        .we_i   (hsi),
        .waddr_i(wr_ptr[FIFO_SIZE-1:0]),
        .wdata_i(elem_in_i),
        .raddr_i(rd_ptr[FIFO_SIZE-1:0]),
        .rdata_o(elem_out)
    );
  end else begin : g_mem
    register #(
        .ELEM_WIDTH (ELEM_WIDTH),
        .RESET_VALUE('0)
    ) u_mem (
        .clk_i  (clk_i),
        .arst_ni(arst_ni),
        .en_i   (hsi),
        .d_i    (elem_in_i),
        .q_o    (elem_out)
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
