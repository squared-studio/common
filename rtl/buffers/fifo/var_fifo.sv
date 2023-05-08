////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : ...
//    DESCRIPTION : ...
//
////////////////////////////////////////////////////////////////////////////////////////////////////

/*
                                         clk_i                     arst_n
                                        ---↓--------------------------↓---
                                       ¦                                  ¦
[$clog2(NUM_ELEM+1)] data_in_num_lanes →                                  ← [$clog2(NUM_ELEM+1)] data_out_num_lanes
 [$clog2(NUM_ELEM)] data_in_start_lane →                                  ← [$clog2(NUM_ELEM)] data_out_start_lane
                     data_in_req_valid ←                                  → data_out_req_valid
                                       ¦             var_fifo             ¦
        [NUM_ELEM][ELEM_WIDTH] data_in →                                  → [NUM_ELEM][ELEM_WIDTH] data_out
                         data_in_valid →                                  → data_out_valid
                         data_in_ready ←                                  ← data_out_ready
                                       ¦                                  ¦
                                        ---↓--------------------------↓---
                                        space_available     elem_available
                                 [$clog2(FIFO_DEPTH+1)]     [$clog2(FIFO_DEPTH+1)]
*/

module var_fifo #(
    parameter ELEM_WIDTH = 8,
    parameter NUM_ELEM   = 4,
    parameter FIFO_DEPTH = 4 * NUM_ELEM
) (
    input logic clk_i,
    input logic arst_n,

    input  logic [$clog2(NUM_ELEM+1)-1:0] data_in_num_lanes,
    input  logic [  $clog2(NUM_ELEM)-1:0] data_in_start_lane,
    output logic                          data_in_req_valid,

    input  logic [NUM_ELEM-1:0][ELEM_WIDTH-1:0] data_in,
    input  logic                                data_in_valid,
    output logic                                data_in_ready,

    input  logic [$clog2(NUM_ELEM+1)-1:0] data_out_num_lanes,
    input  logic [  $clog2(NUM_ELEM)-1:0] data_out_start_lane,
    output logic                          data_out_req_valid,

    output logic [NUM_ELEM-1:0][ELEM_WIDTH-1:0] data_out,
    output logic                                data_out_valid,
    input  logic                                data_out_ready,

    output logic [$clog2(FIFO_DEPTH+1)-1:0] space_available,
    output logic [$clog2(FIFO_DEPTH+1)-1:0] elem_available
);

  logic [$clog2(NUM_ELEM+1)-1:0] wr_ptr;
  logic [$clog2(NUM_ELEM+1)-1:0] rd_ptr;
  logic [$clog2(NUM_ELEM+1)-1:0] wr_ptr_next;
  logic [$clog2(NUM_ELEM+1)-1:0] rd_ptr_next;
  logic [$clog2(FIFO_DEPTH+1)-1:0] elem_available_next;
  logic [$clog2(FIFO_DEPTH+1)-1:0] num_data_ins;
  logic [$clog2(FIFO_DEPTH+1)-1:0] num_data_outs;

  logic [NUM_ELEM-1:0][ELEM_WIDTH-1:0] data_in_x;
  logic [NUM_ELEM-1:0][ELEM_WIDTH-1:0] data_out_x;

  logic in_handshake;
  logic out_handshake;

  logic [FIFO_DEPTH-1:0][ELEM_WIDTH-1:0] mem;

  logic [NUM_ELEM-1:0][$clog2(NUM_ELEM)-1:0] data_in_xbar_select;
  logic [NUM_ELEM-1:0][$clog2(NUM_ELEM)-1:0] data_out_xbar_select;

  assign data_in_req_valid = ((data_in_start_lane + data_in_num_lanes) > NUM_ELEM) ? '0 : '1;
  assign data_in_ready = data_in_req_valid ? ((space_available < data_in_num_lanes) ? '0 : '1) : '0;
  assign data_out_req_valid = ((data_out_start_lane + data_out_num_lanes) > NUM_ELEM) ? '0 : '1;

  assign data_out_valid = data_out_req_valid ? ((elem_available<data_out_num_lanes) ? '0 : '1) : '0;
  assign space_available = FIFO_DEPTH - elem_available;

  assign in_handshake = data_in_valid & data_in_ready;
  assign out_handshake = data_out_valid & data_out_ready;

  assign num_data_ins = in_handshake ? data_in_num_lanes : '0;
  assign num_data_outs = out_handshake ? data_out_num_lanes : '0;

  assign elem_available_next = elem_available + num_data_ins - num_data_outs;

  assign wr_ptr_next = ((wr_ptr+data_in_num_lanes)<FIFO_DEPTH) ? (wr_ptr+data_in_num_lanes) : ((wr_ptr+data_in_num_lanes)-FIFO_DEPTH);
  assign rd_ptr_next = ((rd_ptr+data_out_num_lanes)<FIFO_DEPTH) ? (rd_ptr+data_out_num_lanes) : ((rd_ptr+data_out_num_lanes)-FIFO_DEPTH);

  generate
    for (genvar i = 0; i < NUM_ELEM; i++) begin
      assign data_in_xbar_select[i] = i + data_in_start_lane;
    end
  endgenerate

  generate  // TODO : CHECK 
    for (genvar i = 0; i < NUM_ELEM; i++) begin
      assign data_out_xbar_select [i] = (i < data_out_start_lane) ? ((i+NUM_ELEM) - data_out_start_lane) : (i - data_out_start_lane);
    end
  endgenerate

  generate
    for (genvar i = 0; i < NUM_ELEM; i++) begin
      assign data_out_x[i] = mem[((rd_ptr+i)<FIFO_DEPTH)?(rd_ptr+i) : ((rd_ptr+i)-FIFO_DEPTH)];
    end
  endgenerate

  xbar #(
      .ELEM_WIDTH(ELEM_WIDTH),
      .NUM_ELEM  (NUM_ELEM)
  ) xbar_data_in (
      .input_select(data_in_xbar_select),
      .inputs      (data_in),
      .outputs     (data_in_x)
  );

  xbar #(
      .ELEM_WIDTH(ELEM_WIDTH),
      .NUM_ELEM  (NUM_ELEM)
  ) xbar_data_out (
      .input_select(data_out_xbar_select),
      .inputs      (data_out_x),
      .outputs     (data_out)
  );

  always_ff @(posedge clk_i or negedge arst_n) begin
    if (~arst_n) begin
      elem_available <= '0;
      wr_ptr <= '0;
      rd_ptr <= '0;
    end else begin
      elem_available <= elem_available_next;
      if (in_handshake) begin
        wr_ptr <= wr_ptr_next;
        for (int i = 0; i < NUM_ELEM; i++) begin
          if (i < data_in_num_lanes) begin
            mem[wr_ptr+i] <= data_in_x[i];
          end
        end
      end
      if (out_handshake) begin
        rd_ptr <= rd_ptr_next;
      end
    end
  end

endmodule
