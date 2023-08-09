module up_down_counter #(
  parameter int COUNT = 16      // max value of count
)(
  input logic                       clk_i,
  input logic                       arstn_i,
  input logic                       up_i,
  input logic                       down_i,
  output logic [$clog2(COUNT)-1:0]  count_o
);

always_ff @(posedge clk_i or negedge arstn_i) begin
  if (~arstn_i) begin
    count_o <= '0;
  end
  else if (up_i) begin
    count_o++;
  end
  else if (down_i)begin
    count_o--;
  end
end

endmodule
