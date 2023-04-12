/* 
                           clk_i             arst_n               en
                          ---↓------------------↓------------------↓---
                         ¦                                              ¦
[PARALLEL_WIDTH] data_in →                     piso                     → [SERIAL_WIDTH] data_out
                    load →                                              ¦
                          ----------------------------------------------
*/

module piso #(
    parameter  SERIAL_WIDTH   = 8,
    parameter  DEPTH          = 5,
    parameter  LEFT_SHIFT     = 1,
    localparam PARALLEL_WIDTH = (SERIAL_WIDTH * DEPTH)
) (
    input  logic                      clk_i,
    input  logic                      arst_n,
    input  logic                      en,
    input  logic [PARALLEL_WIDTH-1:0] data_in,
    output logic [SERIAL_WIDTH-1:0]   data_out
);
  
    logic [DEPTH-1:0][SERIAL_WIDTH-1:0] mem;

    assign data_out = mem;

    always_ff @( posedge clk_i or negedge arst_n ) begin : main
        if (~arst_n) begin : do_reset
            for (int i = 0; i < DEPTH; i++) begin
                mem [i] <= '0;
            end
        end

        else begin : not_reset
            if (en) begin
                if (LEFT_SHIFT) begin
                    mem [0] <= data_in;
                    for (int i = 1; i < DEPTH; i++) begin
                        mem [i] <= mem [i-1];
                    end
                end
                else begin
                    mem [DEPTH-1] <= data_in;
                    for (int i = 1; i < DEPTH; i++) begin
                        mem [i-1] <= mem [i];
                    end
                end
            end
        end
    end

endmodule