// Edge Detector Module Async
// ### Author : Foez Ahmed (foez.official@gmail.com)

module edge_detector_async #(
    parameter bit POSEDGE = 1,  // detect positive edge
    parameter bit NEGEDGE = 1   // detect negative edge
) (
    input  logic arst_ni,    // Asynchronous reset
    input  logic clk_i,      // Global clock
    input  logic d_i,        // Data in
    output logic posedge_o,  // posedge detected
    output logic negedge_o   // negedge detected
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic q;  // previous d_i

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  if (POSEDGE) begin : g_pos_assign
    assign posedge_o = d_i & ~q;
  end else begin : g_pos_default
    assign posedge_o = '0;
  end

  if (NEGEDGE) begin : g_neg_assign
    assign negedge_o = ~d_i & q;
  end else begin : g_neg_default
    assign negedge_o = '0;
  end

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SEQUENTIAL
  //////////////////////////////////////////////////////////////////////////////////////////////////

  always_ff @(posedge clk_i or negedge arst_ni) begin
    if (~arst_ni) begin
      q <= '0;
    end else begin
      q <= d_i;
    end
  end

endmodule
