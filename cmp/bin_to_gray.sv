////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : ...
//    DESCRIPTION : ...
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module bin_to_gray #(
    parameter DATA_WIDTH = 4
) ( 
    input  logic [DATA_WIDTH-1:0] data_in,
    output logic [DATA_WIDTH-1:0] data_out
);

    generate
        assign data_out [DATA_WIDTH-1] = data_in [DATA_WIDTH-1];
        for (genvar i = 0; i < (DATA_WIDTH-1); i++) begin
            assign data_out [i] = data_in [1+i] ^ data_in [i];
        end
    endgenerate
        
endmodule