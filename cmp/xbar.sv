module xbar #(
    parameter ELEM_WIDTH = 8,
    parameter NUM_ELEM   = 6
) (
    input  logic [NUM_ELEM-1:0][$clog2(NUM_ELEM)-1:0] input_select,
    input  logic [NUM_ELEM-1:0][ELEM_WIDTH-1:0]       inputs      ,
    output logic [NUM_ELEM-1:0][ELEM_WIDTH-1:0]       outputs     
);

    always_comb begin : main
        for (int i = 0; i < NUM_ELEM ; i++) begin
            outputs [i] = (input_select[i]<NUM_ELEM) ? inputs[input_select[i]] : inputs[input_select[i]-NUM_ELEM];
        end
    end

endmodule