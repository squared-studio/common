////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : ...
//    DESCRIPTION : ...
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module xbar_tb;

    // Parameters
    localparam int ElemWidth = 4;
    localparam int NumElem = 6;

    // Ports
    logic [NumElem-1:0][      ElemWidth-1:0] inputs;
    logic [NumElem-1:0][$clog2(NumElem)-1:0] input_select;
    logic [NumElem-1:0][      ElemWidth-1:0] outputs;

    xbar #(
        .ElemWidth(ElemWidth),
        .NumElem  (NumElem)
    ) xbar_dut (
        .input_select(input_select),
        .inputs(inputs),
        .outputs(outputs)
    );

    initial begin
        inputs       <= '{10, 11, 12, 13, 14, 15};
        input_select <= '{0, 0, 2, 2, 1, 1};
        #100;
        $display("IP: %p", inputs);
        $display("SE: %p", input_select);
        $display("OP: %p", outputs);
        $finish;
    end

endmodule
