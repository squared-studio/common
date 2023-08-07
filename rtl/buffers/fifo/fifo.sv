// Simple synchronous FIFO with asynchronous reset. Operates with validity handshake protocol.
// ### Author : Foez Ahmed (foez.official@gmail.com)

module fifo #(
    parameter int ELEM_WIDTH = 8,  // Width of each element
    parameter int DEPTH      = 5   // Number of elements that can be stored in the FIFO
) (
    input logic clk_i,   // Synchronous clock
    input logic arst_ni, // Asynchronous reset

    input  logic [ELEM_WIDTH-1:0] elem_in_i,        // Input element
    input  logic                  elem_in_valid_i,  // Input element valid
    output logic                  elem_in_ready_o,  // Input element ready

    output logic [ELEM_WIDTH-1:0] elem_out_o,        // Output element
    output logic                  elem_out_valid_o,  // Output element valid
    input  logic                  elem_out_ready_i,  // Output element ready

    output logic [$clog2(DEPTH):0] el_cnt_o  // Available element count
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [$clog2(DEPTH):0] wr_ptr;  // Write pointer
  logic [$clog2(DEPTH):0] rd_ptr;  // Read pointer
  logic [$clog2(DEPTH):0] wr_ptr_next;  // Write pointer next
  logic [$clog2(DEPTH):0] rd_ptr_next;  // Read pointer next

  logic elem_in_hs;  // Input handshake
  logic elem_out_hs;  // Output handshake

  logic [ELEM_WIDTH-1:0] rdata_o;  // Mem read out

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign elem_in_ready_o = (el_cnt_o == DEPTH) ? elem_out_ready_i : '1;
  assign elem_out_valid_o = (el_cnt_o == '0) ? elem_in_valid_i : '1;

  assign elem_in_hs = elem_in_valid_i & elem_in_ready_o;
  assign elem_out_hs = elem_out_valid_o & elem_out_ready_i;

  assign wr_ptr_next = ((wr_ptr + 1) == DEPTH) ? '0 : wr_ptr + 1;
  assign rd_ptr_next = ((rd_ptr + 1) == DEPTH) ? '0 : rd_ptr + 1;

  assign elem_out_o = el_cnt_o ? rdata_o : elem_in_i;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  mem #(
      .ELEM_WIDTH(ELEM_WIDTH),
      .DEPTH(DEPTH)
  ) mem_dut (
      .clk_i(clk_i),
      .arst_ni('1),
      .we_i(elem_in_hs),
      .waddr_i(wr_ptr),
      .wdata_i(elem_in_i),
      .raddr_i(rd_ptr),
      .rdata_o(rdata_o)
  );

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SEQUENCIALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // Update pointers and memory
  always_ff @(posedge clk_i or negedge arst_ni) begin
    if (~arst_ni) begin : not_reset  // Apply reset
      el_cnt_o <= '0;
      wr_ptr   <= '0;
      rd_ptr   <= '0;
    end else begin : do_reset  // Update pointers and memory
      case ({
        elem_out_hs, elem_in_hs
      })
        2'b11: begin  // Both side handshake
          el_cnt_o <= el_cnt_o;
          rd_ptr   <= rd_ptr_next;
          wr_ptr   <= wr_ptr_next;
        end
        2'b10: begin  // Output handshake only
          el_cnt_o <= el_cnt_o - 1;
          rd_ptr   <= rd_ptr_next;
          wr_ptr   <= wr_ptr;
        end
        2'b01: begin  // Input handshake only
          el_cnt_o <= el_cnt_o + 1;
          rd_ptr   <= rd_ptr;
          wr_ptr   <= wr_ptr_next;
        end
        default: begin  // Latch on
          el_cnt_o <= el_cnt_o;
          rd_ptr   <= rd_ptr;
          wr_ptr   <= wr_ptr;
        end
      endcase
    end
  end

endmodule
