// A simple up down counter that counts up to MAX_COUNT
// ### Author : Md. Mohiuddin Reyad (mreyad30207@gmail.com)

module up_down_counter #(
    parameter int                  MAX_COUNT   = 25,  // max value of count
    parameter bit [ELEM_WIDTH-1:0] RESET_VALUE = '0
) (
    input  logic                         clk_i,
    input  logic                         arstn_i,
    input  logic                         up_i,
    input  logic                         down_i,
    output logic [$clog2(MAX_COUNT)-1:0] count_o
);

  always_ff @(posedge clk_i or negedge arstn_i) begin
    if (~arstn_i) begin
      count_o <= RESET_VALUE;
    end else if (up_i && ~down_i) begin
      if (count_o == MAX_COUNT) begin
        count_o <= '0;
      end else begin
        count_o <= count + 1;
      end
    end else if (down_i && ~up_i) begin
      if (count_o == '0) begin
        count_o <= MAX_COUNT;
      end else begin
        count_o <= count_o - 1;
      end
    end else begin
      count_o <= '0;
    end
  end

endmodule
