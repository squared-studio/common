/*
The `pll_model` module is a model of a Phase-Locked Loop (PLL). It takes in a reference frequency
and outputs a frequency that is locked to the reference frequency.
Author: Foez Ahmed (foez.official@gmail.com)
*/

module pll_model (
    input logic bypass_i,  // bypass the reference frequency to fout_o

    input logic       fref_i,   // reference frequency
    input logic [7:0] refdiv_i, // reference frequency divider

    output logic lock_o,  // PLL lock

    input  logic [15:0] fbdiv_i,  // VCO feedback voltage divider
    output logic        fvco_o,   // VCO frequency

    input  logic [7:0] fdiv_i,  // output frequency divider
    output logic       fout_o   // output frequency
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-VARIABLES
  //////////////////////////////////////////////////////////////////////////////////////////////////

  realtime fref_time_period = 0;  // Time period of fref_i after division
  realtime fvco_time_period = 1us;  // Time period of fvco_o
  realtime old_fref_tick = 0ns;  // divided fref_i previous posedge time
  realtime new_fref_tick = 100ns;  // divided fref_i current posedge time

  logic fout_ff;  // divided fvco_o

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // if bypassed, switch to fref_i
  // Otherwise if fdiv is 1, directly pass fvco as there is no need of frequency division,
  // else pass the divided fvoc_o
  assign fout_o = bypass_i ? fref_i : ((fdiv_i == 1) ? fvco_o : fout_ff);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-PROCEDURALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  always @(posedge fref_i) begin

    // handling the refdiv here. Wait additional cycles for calculating time period
    automatic int rpt;
    rpt = (refdiv_i > 0) ? (refdiv_i - 1) : 1;
    repeat (rpt) @(posedge fref_i);

    // Calculating time period
    new_fref_tick = $realtime;
    fref_time_period = (new_fref_tick - old_fref_tick);
    old_fref_tick = new_fref_tick;

    // Digital low pass fileted for soomthly transitioning frequency
    fvco_time_period = fvco_time_period * 0.9 + 0.1 * (fref_time_period / fbdiv_i);

    // Determine if desired frequency is achieved
    lock_o <= (fref_time_period / (fvco_time_period * fbdiv_i)) inside {[0.999 : 1.001]};
  end

  // Toggling fvco_o
  always begin
    fvco_o <= '1;
    #(fvco_time_period / 2);
    fvco_o <= '0;
    #(fvco_time_period / 2);
  end

  // dividing the fvco_o by fdiv to get fout_o
  always begin
    automatic int hc;
    automatic int lc;
    hc = fdiv_i[7:1];
    lc = (fdiv_i[0]) ? (fdiv_i[7:1] + 1) : (fdiv_i[7:1]);
    fout_ff <= '1;
    repeat (hc) @(posedge fvco_o);
    fout_ff <= '0;
    repeat (lc) @(posedge fvco_o);
  end

  // defining time format
  initial begin
    $timeformat(-12, 3, "ps");
  end

endmodule
