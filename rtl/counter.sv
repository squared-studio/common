// A simple up down counter that counts up to MAX_COUNT
// ### Author : Md. Mohiuddin Reyad (mreyad30207@gmail.com)

module counter #(
    parameter int                           MAX_COUNT   = 25,
    parameter bit [$clog2(MAX_COUNT+1)-1:0] RESET_VALUE = '0,
    parameter bit                           UP_COUNT    = 1,
    parameter bit                           DOWN_COUNT  = 1
) (
    input logic clk_i,
    input logic arst_ni,

    input logic up_i,
    input logic down_i,

    output logic [$clog2(MAX_COUNT+1)-1:0] count_o
);

  if (UP_COUNT && DOWN_COUNT) begin : g_up_down
    always_ff @(posedge clk_i or negedge arst_ni) begin
      if (~arst_ni) begin
        count_o <= RESET_VALUE;
      end else if (up_i ^ down_i) begin
        if (up_i) begin
          if (count_o == MAX_COUNT) count_o <= '0;
          else count_o <= count_o + 1;
        end else begin
          if (count_o == '0) count_o <= MAX_COUNT;
          else count_o <= count_o - 1;
        end
      end
    end
  end else if (UP_COUNT && !DOWN_COUNT) begin : g_up
    always_ff @(posedge clk_i or negedge arst_ni) begin
      if (~arst_ni) begin
        count_o <= RESET_VALUE;
      end else if (up_i) begin
        if (count_o == MAX_COUNT) count_o <= '0;
        else count_o <= count_o + 1;
      end
    end
  end else if (!UP_COUNT && DOWN_COUNT) begin : g_down
    always_ff @(posedge clk_i or negedge arst_ni) begin
      if (~arst_ni) begin
        count_o <= RESET_VALUE;
      end else if (down_i) begin
        if (count_o == '0) count_o <= MAX_COUNT;
        else count_o <= count_o - 1;
      end
    end
  end else begin : g_nothing
    assign count_o = '0;
  end

endmodule

// TODO
