////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : ...
//    DESCRIPTION : ...
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module jk_ff (
    input  logic clk_i,
    input  logic arst_n,
    input  logic j,
    input  logic k,
    output logic q,
    output logic q_n
);

    assign q_n = ~q;

    always_ff @(posedge clk_i or negedge arst_n) begin
        if (~arst_n) begin
            q <= 0;
        end
        else begin
            case ({j,k})
                2'b01   : q <= '0;
                2'b10   : q <= '1;
                2'b11   : q <= q_n;
                default : q <= q;
            endcase
        end
    end

endmodule