module pll (
    input logic bypass_i,

    input logic       fref_i,
    input logic [7:0] refdiv_i,

    output logic lock_o,

    input  logic [15:0] fbdiv_i,
    output logic        fvco_o,

    input  logic [7:0] fdiv_i,
    output logic       fout_o
);

  realtime old_fref_tick = 0ns;
  realtime new_fref_tick = 100ns;
  realtime fref_time_period = 0;
  realtime fvco_time_period = 1us;

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
    fvco_time_period = fvco_time_period * 0.9 + 0.1 * (fref_time_period / fbdiv_i);
    old_fref_tick = new_fref_tick;
  end

  always @(posedge fvco_o) begin
    lock_o <= (fref_time_period / (fvco_time_period * fbdiv_i)) inside {[0.999 : 1.001]};
  end

  always begin
    fvco_o <= '1;
    #(fvco_time_period / 2);
    fvco_o <= '0;
    #(fvco_time_period / 2);
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

  assign fout_o = (fdiv_i == 1) ? fvco_o : fout_ff;

endmodule
