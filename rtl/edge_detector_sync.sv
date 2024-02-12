// Edge Detector Module Sync
// ### Author : Foez Ahmed (foez.official@gmail.com)

module edge_detector_sync #(
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
  //-SIGNALS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic posedge_buff;
  logic negedge_buff;

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  edge_detector_async #(
      .POSEDGE(POSEDGE),
      .NEGEDGE(NEGEDGE)
  ) u_edge_detector_async (
      .arst_ni  (arst_ni),
      .clk_i    (clk_i),
      .d_i      (d_i),
      .posedge_o(posedge_buff),
      .negedge_o(negedge_buff)
  );

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SEQUENTIAL{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  always_ff @(posedge clk_i or negedge arst_ni) begin
    if (~arst_ni) begin
      posedge_o <= '0;
      negedge_o <= '0;
    end else begin
      posedge_o <= posedge_buff;
      negedge_o <= negedge_buff;
    end

  end

  //}}}

endmodule
