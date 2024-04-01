/*
The `clk_div` module is a frequency divider with a configurable divisor.

When the divisor is 1 or 0, the frequency division is bypassed, and the output clock is the same as
the input clock. Otherwise, the frequency division is performed by counting the clock cycles and
toggling the output clock when the count reaches the high or low count threshold.

The clock frequency divider uses sequential logic to implement the frequency division. The sequential
logic is sensitive to the rising edge of the input clock and the falling edge of the reset signal.
When the reset signal is not asserted, the counter is incremented at each clock cycle, and the
output clock is toggled when the count reaches the high or low count threshold.

Author : Foez Ahmed (foez.official@gmail.com)
*/

module clk_div #(
    parameter int DIVISOR_SIZE = 9  // size of the divisor register
) (
    input logic arst_ni,  // asynchronous global reset signal

    // clock divisor
    input logic [DIVISOR_SIZE-1:0] divisor_i,

    input logic clk_i,  // input clock signal

    output logic clk_o  // output clock signal
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic bypass;  // bypass when divisor is 1 or 0
  logic clk;  // output clock if not bypassed

  logic [DIVISOR_SIZE-1:0] count;  // counter for frequency division
  logic [DIVISOR_SIZE-1:0] count_p1;  // counter value+1

  logic [DIVISOR_SIZE-1:0] hct;  // high count threshold
  logic [DIVISOR_SIZE-1:0] lct;  // low count threshold

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign bypass = (divisor_i < 2);
  assign count_p1 = count + 1;

  // round down division by 2
  assign hct = divisor_i[DIVISOR_SIZE-1:1];
  // increase the lct for odd divisor
  assign lct = divisor_i[DIVISOR_SIZE-1:1] + divisor_i[0];

  assign clk_o = bypass ? clk_i : clk;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SEQUENTIALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  always_ff @(posedge clk_i or negedge arst_ni) begin
    if (~arst_ni) begin
      clk   <= '0;
      count <= '1;
    end else begin
      if (clk == 0) begin
        if (count_p1 == lct) begin
          count <= '0;
          clk   <= '1;
        end else begin
          count <= count_p1;
        end
      end else begin
        if (count_p1 == hct) begin
          count <= '0;
          clk   <= '0;
        end else begin
          count <= count_p1;
        end
      end
    end
  end

endmodule
