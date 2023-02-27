/* 
                  clk_i                            arst_n
                 ---↓--------------------------------------↓---
                ¦                                              ¦
[WIDTH] data_in →                                              → [WIDTH] data_out
  data_in_valid →                   pipeline                   → data_out_valid
  data_in_ready ←                                              ← data_out_ready
                ¦                                              ¦
                 ----------------------------------------------
*/

module pipeline #(
  parameter WIDTH      = 8,
  parameter NUM_STAGES = 1
) (
  input  logic             clk_i,
  input  logic             arst_n,

  input  logic [WIDTH-1:0] data_in,
  input  logic             data_in_valid,
  output logic             data_in_ready,

  output logic [WIDTH-1:0] data_out,
  output logic             data_out_valid,
  input  logic             data_out_ready
);

  generate

    if (NUM_STAGES == 0) begin
      assign data_out       = data_in;
      assign data_out_valid = data_in_valid;
      assign data_in_ready  = data_out_ready;
    end

    else if (NUM_STAGES == 1) begin
      pipeline_core #(
        .WIDTH (WIDTH)
      ) u_pipeline_core (
        .clk_i          ( clk_i          ),
        .arst_n         ( arst_n         ),
        .data_in        ( data_in        ),
        .data_in_valid  ( data_in_valid  ),
        .data_in_ready  ( data_in_ready  ),
        .data_out       ( data_out       ),
        .data_out_valid ( data_out_valid ),
        .data_out_ready ( data_out_ready )
      );
    end
    
    else begin

      logic [WIDTH-1:0] data_  [NUM_STAGES-1];
      logic             valid_ [NUM_STAGES-1];
      logic             ready_ [NUM_STAGES-1];

      pipeline_core #(
        .WIDTH (WIDTH)
      ) u_pipeline_core_first (
        .clk_i          ( clk_i          ),
        .arst_n         ( arst_n         ),
        .data_in        ( data_in        ),
        .data_in_valid  ( data_in_valid  ),
        .data_in_ready  ( data_in_ready  ),
        .data_out       ( data_[0]       ),
        .data_out_valid ( valid_[0]      ),
        .data_out_ready ( ready_[0]      )
      );

      for (genvar i = 0; i < (NUM_STAGES-2) ; i++) begin
        pipeline_core #(
          .WIDTH (WIDTH)
        ) u_pipeline_core_middle (
          .clk_i          ( clk_i     ),
          .arst_n         ( arst_n    ),
          .data_in        ( data_[i]  ),
          .data_in_valid  ( valid_[i] ),
          .data_in_ready  ( ready_[i] ),
          .data_out       ( data_[i+1]  ),
          .data_out_valid ( valid_[i+1] ),
          .data_out_ready ( ready_[i+1] )
        );
      end

      pipeline_core #(
        .WIDTH (WIDTH)
      ) u_pipeline_core_last (
        .clk_i          ( clk_i                ),
        .arst_n         ( arst_n               ),
        .data_in        ( data_[NUM_STAGES-2]  ),
        .data_in_valid  ( valid_[NUM_STAGES-2] ),
        .data_in_ready  ( ready_[NUM_STAGES-2] ),
        .data_out       ( data_out             ),
        .data_out_valid ( data_out_valid       ),
        .data_out_ready ( data_out_ready       )
      );

    end

  endgenerate

endmodule