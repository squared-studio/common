/*
The `counter` module is a configurable counter that can count up, down, or both based on the parameters set.

The counter's functionality is determined by the `UP_COUNT` and `DOWN_COUNT` parameters:

- If both `UP_COUNT` and `DOWN_COUNT` are enabled (`g_up_down`), the counter will increment if `up_i` is high and decrement if `down_i` is high. If the counter reaches `MAX_COUNT` while incrementing, it will wrap around to 0. Similarly, if it reaches 0 while decrementing, it will wrap around to `MAX_COUNT`.
- If only `UP_COUNT` is enabled (`g_up`), the counter will increment if `up_i` is high. It will wrap around to 0 if it reaches `MAX_COUNT`.
- If only `DOWN_COUNT` is enabled (`g_down`), the counter will decrement if `down_i` is high. It will wrap around to `MAX_COUNT` if it reaches 0.
- If neither `UP_COUNT` nor `DOWN_COUNT` is enabled (`g_nothing`), the counter will not change and `count_o` will always be 0.

The counter is reset to `RESET_VALUE` whenever `arst_ni` is low. The counter updates on the rising edge of `clk_i`.

  Author : Md. Mohiuddin Reyad (mreyad30207@gmail.com)
*/

module counter #(
    parameter int MAX_COUNT = 25,  // maximum count value
    parameter bit [$clog2(MAX_COUNT+1)-1:0] RESET_VALUE = '0,  // value to reset the counter to
    parameter bit UP_COUNT = 1,  // If set to 1, the counter will increment
    parameter bit DOWN_COUNT = 1  // If set to 1, the counter will decrement
) (
    input logic clk_i,   // clock input
    input logic arst_ni, // asynchronous active low reset input

    input logic up_i,   // increment control input
    input logic down_i, // decrement control input

    output logic [$clog2(MAX_COUNT+1)-1:0] count_o  // current count value
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SEQUENTIALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

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
