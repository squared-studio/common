////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : ...
//    DESCRIPTION : ...
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module decoder #(
    parameter CODE_WIDTH = 4
) (
    input  logic [CODE_WIDTH-1:0]    code,
    output logic [2**CODE_WIDTH-1:0] out
);

    generate
        for (genvar i=0; i<(2**CODE_WIDTH); i++) begin
            assign out[i] = (code==i);
        end
    endgenerate

endmodule