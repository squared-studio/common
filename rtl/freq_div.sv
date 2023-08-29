module freq_div #(
    parameter int DIVISOR = 3
) (
    input  logic arst_ni,
    input  logic clk_i,
    output logic clk_o
);

  if (DIVISOR < 2) begin : g_bypass
    assign clk_o = clk_i;
  end else begin : g_div
    localparam int EQ = !(DIVISOR % 2);
    localparam int HC = (DIVISOR >> 1);
    localparam int LC = EQ ? (DIVISOR >> 1) : ((DIVISOR >> 1) + 1);

    logic [$clog2(DIVISOR+1)-1:0] count;
    logic [$clog2(DIVISOR+1)-1:0] count_next;

    assign count_next = count + 1;

    if (EQ) begin : g_EQ
      always_ff @(posedge clk_i or negedge arst_ni) begin
        if (~arst_ni) begin
          count <= '0;
          clk_o <= '0;
        end else begin
          if (count_next == LC) begin
            clk_o <= ~clk_o;
            count <= '0;
          end else begin
            count <= count_next;
          end
        end
      end
    end else begin : g_nEQ
      always_ff @(posedge clk_i or negedge arst_ni) begin
        if (~arst_ni) begin
          count <= '0;
          clk_o <= '0;
        end else begin
          if (clk_o) begin
            if (count_next == HC) begin
              clk_o <= '0;
              count <= '0;
            end else begin
              count <= count_next;
            end
          end else begin
            if (count_next == LC) begin
              clk_o <= '1;
              count <= '0;
            end else begin
              count <= count_next;
            end
          end
        end
      end
    end
  end

endmodule
