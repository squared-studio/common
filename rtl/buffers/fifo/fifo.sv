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
                        clk_i       arst_ni
                       ---↓------------↓---
                      ¦                    ¦
[DataWidth] data_in_i →                    → [DataWidth] data_out_o
      data_in_valid_i →        fifo        → data_out_valid_o
      data_in_ready_o ←                    ← data_out_ready_i
                      ¦                    ¦
                       --------------------
*/

module fifo #(
    parameter int DataWidth = 8,
    parameter int Depth = 5
) (
    input  logic                 clk_i,
    input  logic                 arst_ni,

    input  logic [DataWidth-1:0] data_in_i,
    input  logic                 data_in_valid_i,
    output logic                 data_in_ready_o,

    output logic [DataWidth-1:0] data_out_o,
    output logic                 data_out_valid_o,
    input  logic                 data_out_ready_i
);

    logic [DataWidth-1:0] mem [Depth];

    logic [$clog2(Depth):0] dt_cnt;
    logic [$clog2(Depth):0] wr_ptr;
    logic [$clog2(Depth):0] rd_ptr;
    logic [$clog2(Depth):0] wr_ptr_next;
    logic [$clog2(Depth):0] rd_ptr_next;

    logic data_in_hs;
    logic data_out_hs;

    assign data_in_ready_o  = (dt_cnt == Depth) ? data_out_ready_i : 1;
    assign data_out_valid_o = (dt_cnt == 0) ? data_in_valid_i : '1;

    assign data_in_hs  = data_in_valid_i  & data_in_ready_o;
    assign data_out_hs = data_out_valid_o & data_out_ready_i;

    assign wr_ptr_next = ((wr_ptr+1)<Depth) ? wr_ptr+1 : '0;
    assign rd_ptr_next = ((rd_ptr+1)<Depth) ? rd_ptr+1 : '0;

    assign data_out_o = dt_cnt ? mem [rd_ptr] : data_in_i;

    always_ff @( posedge clk_i or negedge arst_ni ) begin : main
        if (~arst_ni) begin : not_reset
            dt_cnt <= '0;
            wr_ptr <= '0;
            rd_ptr <= '0;
        end
        else begin : do_reset
            case ({data_out_hs,data_in_hs})
                2'b11  : begin dt_cnt <= dt_cnt;   rd_ptr <= rd_ptr_next; wr_ptr <= wr_ptr_next; end
                2'b10  : begin dt_cnt <= dt_cnt-1; rd_ptr <= rd_ptr_next; wr_ptr <= wr_ptr;      end
                2'b01  : begin dt_cnt <= dt_cnt+1; rd_ptr <= rd_ptr;      wr_ptr <= wr_ptr_next; end
                default: begin dt_cnt <= dt_cnt;   rd_ptr <= rd_ptr;      wr_ptr <= wr_ptr;      end
            endcase
            if (data_in_hs) mem [wr_ptr] <= data_in_i;
        end
    end

endmodule
