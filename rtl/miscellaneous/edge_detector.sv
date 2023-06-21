// Description
// ### Author : Foez Ahmed (foez.official@gmail.com)

module edge_detector #(
    parameter bit POSEDGE = 1,
    parameter bit NEGEDGE = 0
) (
    input  logic arst_ni,
    input  logic clk_i,
    input  logic d_i,
    output logic posedge_o,
    output logic negedge_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  if (POSEDGE) begin : g_pos_dff
    logic q_p;
  end

  if (NEGEDGE) begin : g_neg_dff
    logic q_n;
  end

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  if (POSEDGE) begin : g_pos_assign
    assign posedge_o = d_i & ~q_p;
  end else begin : g_pos_default
    assign posedge_o = '0;
  end

  if (NEGEDGE) begin : g_neg_assign
    assign negedge_o = ~d_i & q_n;
  end else begin : g_neg_default
    assign negedge_o = '0;
  end

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SEQUENCIALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  if (POSEDGE) begin : g_pos_dff_update
    always_ff @(posedge clk_i or negedge arst_ni) begin
      if (~arst_ni) begin
        q_p <= '0;
      end else begin
        q_p <= d_i;
      end
    end
  end

  if (NEGEDGE) begin : g_neg_dff_update
    always_ff @(posedge clk_i or negedge arst_ni) begin
      if (~arst_ni) begin
        q_n <= '1;
      end else begin
        q_n <= d_i;
      end
    end
  end

endmodule
