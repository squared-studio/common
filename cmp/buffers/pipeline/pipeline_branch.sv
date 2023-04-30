/* 
                       clk_i                    arst_n
                      ---↓-------------------------↓---
                     ¦                                 ¦
                     ¦                                 → [DATA_WIDTH] data_out_main
                     ¦                                 → data_out_main_valid
[DATA_WIDTH] data_in →                                 ← data_out_main_ready
       data_in_valid →         pipeline_branch         ¦
       data_in_ready ←                                 → [DATA_WIDTH] data_out_scnd
                     ¦                                 → data_out_scnd_valid
                     ¦                                 ← data_out_scnd_ready
                     ¦                                 ¦
                      ---------------------------------
*/

module pipeline_branch #(
    parameter DATA_WIDTH = 8
) (
    input  logic                  clk_i,
    input  logic                  arst_n,

    input  logic [DATA_WIDTH-1:0] data_in,
    input  logic                  data_in_valid,
    output logic                  data_in_ready,

    output logic [DATA_WIDTH-1:0] data_out_main,
    output logic                  data_out_main_valid,
    input  logic                  data_out_main_ready,

    output logic [DATA_WIDTH-1:0] data_out_scnd,
    output logic                  data_out_scnd_valid,
    input  logic                  data_out_scnd_ready
);

    logic [DATA_WIDTH-1:0] data_out_core;
    logic                  data_out_core_valid;
    logic                  data_out_core_ready;

    assign data_out_main = data_out_core;
    assign data_out_scnd = data_out_core;

    assign data_out_main_valid = data_out_core_valid;
    assign data_out_scnd_valid = data_out_core_valid & ~data_out_main_ready;
    assign data_out_core_ready = data_out_scnd_ready | data_out_main_ready;

    pipeline_core  #( 
        .DATA_WIDTH ( DATA_WIDTH ) 
    ) pipeline_core_dut (
            .clk_i          ( clk_i               ),
            .arst_n         ( arst_n              ),
            .data_in        ( data_in             ),
            .data_in_valid  ( data_in_valid       ),
            .data_in_ready  ( data_in_ready       ),
            .data_out       ( data_out_core       ),
            .data_out_valid ( data_out_core_valid ),
            .data_out_ready ( data_out_core_ready )
    );

endmodule









