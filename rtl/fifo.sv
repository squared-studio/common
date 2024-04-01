/*
The `fifo` module is a First-In-First-Out (FIFO) memory buffer with configurable parameters.

The FIFO operates based on the handshake signals `elem_in_valid_i`, `elem_in_ready_o`,
`elem_out_valid_o` & `elem_out_ready_i`. When the FIFO is not full, it is ready to accept an input
element. When the FIFO is not empty, it is ready to output an element. The FIFO can operate in
either pipelined mode or pass-through mode, depending on the `PIPELINED` parameter.

The FIFO uses registers to store the write and read pointers. It also uses a memory block to store
the elements. The size of the memory block is determined by the `FIFO_SIZE` parameter.

Author : Foez Ahmed (foez.official@gmail.com)
*/

module fifo #(
    //A bit that determines whether the FIFO is pipelined
    parameter bit PIPELINED  = 1,
    //The width of each element in the FIFO
    parameter int ELEM_WIDTH = 8,
    //The number of elements that can be stored in the FIFO
    parameter int FIFO_SIZE  = 4
) (
    // input clock signal
    input logic clk_i,
    // asynchronous active low reset signal
    input logic arst_ni,

    // input element
    input  logic [ELEM_WIDTH-1:0] elem_in_i,
    // input valid signal. It indicates whether the input element is valid
    input  logic                  elem_in_valid_i,
    // input ready signal. It indicates whether the FIFO is ready to accept an input element
    output logic                  elem_in_ready_o,

    // output element
    output logic [ELEM_WIDTH-1:0] elem_out_o,
    // output valid signal. It indicates whether the output element is valid
    output logic                  elem_out_valid_o,
    // output ready signal. It indicates whether the FIFO is ready to output an element
    input  logic                  elem_out_ready_i
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
    if (((2 ** FIFO_SIZE) * ELEM_WIDTH) >= 1024) begin
      $warning("\033[1;33m%m%0d bit FIFO is quite big\033[0m", ((2 ** FIFO_SIZE) * ELEM_WIDTH));
    end
  end
`endif  // SIMULATION

endmodule
