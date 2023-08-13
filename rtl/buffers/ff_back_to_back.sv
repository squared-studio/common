// ### Author : Foez Ahmed (foez.official@gmail.com)

module ff_back_to_back #(
    parameter int NUM_STAGES = 4
) (
    input  logic clk_i,
    input  logic arst_ni,
    input  logic en_i,
    input  logic d_i,
    output logic q_o
);

  if (NUM_STAGES > 1) begin : g_array
    logic [NUM_STAGES-1:0] mem;
    always_ff @(posedge clk_i or negedge arst_ni) begin
      if (~arst_ni) begin
        mem <= '0;
      end else begin
        if (en_i) begin
          mem <= {mem[NUM_STAGES-2:0], d_i};
        end
      end
    end
    assign q_o = mem[NUM_STAGES-1];
  end else if (NUM_STAGES == 1) begin : g_single
    always_ff @(posedge clk_i or negedge arst_ni) begin
      if (~arst_ni) begin
        q_o <= '0;
      end else begin
        if (en_i) begin
          q_o <= d_i;
        end
      end
    end
  end else begin : g_bypass
    assign q_o = d_i;
  end


endmodule

// TODO
