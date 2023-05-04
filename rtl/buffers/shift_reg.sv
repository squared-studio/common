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
                         clk_i   arst_n    load      en    l_shift
                        ---↓--------↓--------↓--------↓--------↓---
                       ¦                                           ¦
       [ELEM_WIDTH] si →                   shift                   → [ELEM_WIDTH] so
[DEPTH][ELEM_WIDTH] pi →                  register                 → [DEPTH][ELEM_WIDTH] po
                       ¦                                           ¦
                        -------------------------------------------
*/

module shift_reg #(
    parameter ELEM_WIDTH = 4,
    parameter DEPTH      = 8
) (
    input  logic                             clk_i,
    input  logic                             arst_n,

    input  logic                             load,
    input  logic                             en,
    input  logic                             l_shift,

    input  logic [ELEM_WIDTH-1:0]            si,
    output logic [ELEM_WIDTH-1:0]            so,

    input  logic [DEPTH-1:0][ELEM_WIDTH-1:0] pi,
    output logic [DEPTH-1:0][ELEM_WIDTH-1:0] po    
);

    assign so = l_shift ? po[DEPTH-1] : po[0];

    always_ff @(posedge clk_i or negedge arst_n) begin
        if (~arst_n) begin
            po <= '0;
        end 
        else if (en) begin
            if (load) begin
                po <= pi;
            end
            else begin
                if (l_shift) begin
                    po[0] <= si;
                    for (int i=1; i<DEPTH; i++) begin
                        po[i] <= po[i-1];
                    end
                end
                else begin
                    po[DEPTH-1] <= si;
                    for (int i=1; i<DEPTH; i++) begin
                        po[i-1] <= po[i];
                    end
                end
            end
        end
    end

endmodule