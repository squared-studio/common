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
    logic [NumElem-1:0][      ElemWidth-1:0] inputs_i;
    logic [NumElem-1:0][$clog2(NumElem)-1:0] input_select_i;
    logic [NumElem-1:0][      ElemWidth-1:0] outputs_o;

    xbar #(
        .ElemWidth(ElemWidth),
        .NumElem  (NumElem)
    ) xbar_dut (
        .input_select_i(input_select_i),
        .inputs_i(inputs_i),
        .outputs_o(outputs_o)
    );

    initial begin
        inputs_i       <= '{10, 11, 12, 13, 14, 15};
        input_select_i <= '{0, 0, 2, 2, 1, 1};
        #100;
        $display("IP: %p", inputs_i);
        $display("SE: %p", input_select_i);
        $display("OP: %p", outputs_o);
        $finish;
    end

endmodule
