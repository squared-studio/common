// Phase Lock Loop circuit model
// ### Author : Foez Ahmed (foez.official@gmail.com)

module pll (
    input logic bypass_i,

    input logic       fref_i,
    input logic [7:0] refdiv_i,

    output logic lock_o,

    input  logic [7:0] fbdiv_i,
    output logic       fvco_o,

    input  logic [7:0] fdiv_i,
    output logic       fout_o
);

  realtime old_fref_tick = 0ns;
  realtime new_fref_tick = 100ns;
  realtime fref_time_period = 0;
  realtime fvco_time_period = 0;

  logic fout_ff;

  initial begin
    $timeformat(-12, 3, "ps");
  end

  always @(posedge fref_i) begin
    int rpt;
    rpt = (refdiv_i > 0) ? (refdiv_i - 1) : 1;
    repeat (rpt) @(posedge fref_i);
    new_fref_tick = $realtime;
    fref_time_period = (new_fref_tick - old_fref_tick);
    if (fvco_time_period == 0) begin
      fvco_time_period <= (fref_time_period / refdiv_i);
    end else begin
      fvco_time_period = fvco_time_period * 0.99 + 0.01 * (fref_time_period / fbdiv_i);
    end
    old_fref_tick = new_fref_tick;
  end

  always @(posedge fvco_o) begin
    if (fvco_time_period == 0) begin
      lock_o <= '0;
    end else begin
      lock_o <= (fref_time_period / (fvco_time_period * fbdiv_i)) inside {[0.999 : 1.001]};
    end
  end

  always begin
    if (fvco_time_period == 0) begin
      @(fref_i);
      fvco_o <= fref_i;
    end else begin
      fvco_o <= '1;
      #(fvco_time_period / 2);
      fvco_o <= '0;
      #(fvco_time_period / 2);
    end
  end

  always begin
    int hc;
    int lc;
    hc = fdiv_i[7:1];
    lc = (fdiv_i[0]) ? (fdiv_i[7:1] + 1) : (fdiv_i[7:1]);
    fout_ff <= '1;
    repeat (hc) @(posedge fvco_o);
    fout_ff <= '0;
    repeat (lc) @(posedge fvco_o);
  end

`ifdef DEBUG
  always #1us begin
    $display("I:%t O:%t", (fref_time_period / fref_i), fvco_time_period);
  end
`endif  // DEBUG

  assign fout_o = bypass_i ? (fref_i) : ((fdiv_i == 1) ? fvco_o : fout_ff);

endmodule
