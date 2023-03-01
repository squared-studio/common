/* 
                       clk_i                            arst_n
                      ---↓--------------------------------------↓---
                     ¦                                              ¦
[DATA_WIDTH] data_in →                                              → [DATA_WIDTH] data_out
       data_in_valid →                     fifo                     → data_out_valid
       data_in_ready ←                                              ← data_out_ready
                     ¦                                              ¦
                      ----------------------------------------------
*/

module fifo #(
  parameter DATA_WIDTH = 8,
  parameter DEPTH      = 5
) (
  input  logic                  clk_i,
  input  logic                  arst_n,

  input  logic [DATA_WIDTH-1:0] data_in,
  input  logic                  data_in_valid,
  output logic                  data_in_ready,

  output logic [DATA_WIDTH-1:0] data_out,
  output logic                  data_out_valid,
  input  logic                  data_out_ready
);

  logic [DATA_WIDTH-1:0] mem [DEPTH];

  logic [$clog2(DEPTH):0] dt_cnt;
  logic [$clog2(DEPTH):0] wr_ptr;
  logic [$clog2(DEPTH):0] rd_ptr;
  logic [$clog2(DEPTH):0] wr_ptr_next;
  logic [$clog2(DEPTH):0] rd_ptr_next;

  logic data_in_hs;
  logic data_out_hs;

  assign data_in_ready  = (dt_cnt < DEPTH);
  assign data_out_valid = (dt_cnt > 0    );

  assign data_in_hs  = data_in_valid  & data_in_ready;
  assign data_out_hs = data_out_valid & data_out_ready;

  assign wr_ptr_next = ((wr_ptr+1)<DEPTH) ? wr_ptr+1 : '0; 
  assign rd_ptr_next = ((rd_ptr+1)<DEPTH) ? rd_ptr+1 : '0; 

  assign data_out = mem [rd_ptr];

  always_ff @( posedge clk_i or negedge arst_n ) begin : main
    if (arst_n) begin : not_reset
      case ({data_out_hs,data_in_hs})
        2'b11  : begin dt_cnt <= dt_cnt;   rd_ptr <= rd_ptr_next; wr_ptr <= wr_ptr_next; end
        2'b10  : begin dt_cnt <= dt_cnt-1; rd_ptr <= rd_ptr_next; wr_ptr <= wr_ptr;      end
        2'b01  : begin dt_cnt <= dt_cnt+1; rd_ptr <= rd_ptr;      wr_ptr <= wr_ptr_next; end
        default: begin dt_cnt <= dt_cnt;   rd_ptr <= rd_ptr;      wr_ptr <= wr_ptr;      end
      endcase
      if (data_in_hs) mem [wr_ptr] <= data_in;
    end
    else begin : do_reset
      dt_cnt <= '0;
      wr_ptr <= '0;
      rd_ptr <= '0;
    end
  end

endmodule