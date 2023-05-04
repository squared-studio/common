////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : ...
//    DESCRIPTION : ...
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module priority_encoder #(
    parameter NUM_INPUTS = 4
) (
    input  logic [NUM_INPUTS-1:0]         in,
    output logic [$clog2(NUM_INPUTS)-1:0] out
);

    logic [$clog2(NUM_INPUTS)-1:0] out_ [NUM_INPUTS];

    assign out = out_[NUM_INPUTS-1];

    generate
        assign out_[0] = 0;
        for (genvar i=1; i<NUM_INPUTS; i++) begin
            assign out_[i] = in[i] ? i : out_[i-1];
        end
    endgenerate

endmodule