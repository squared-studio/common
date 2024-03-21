// Frequency Divider
// ### Author : Foez Ahmed (foez.official@gmail.com)

module freq_div #(
    parameter int DIVISOR_SIZE = 9  // divisor register size
) (
    input logic arst_ni,  // Asynchronous Global Reset

    input logic [DIVISOR_SIZE-1:0] divisor_i,  // clock divisor

    input logic clk_i,  // clock in

    output logic clk_o  // clock out
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
  //-SEQUENTIAL
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
