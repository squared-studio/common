// Simple test bench for clk_gate module
// ### Author : Razu Ahamed(en.razu.ahamed@gmail.com)
module tb_clk_gate;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic cp_i;  //Clock pulse
  logic e_i;  //Enable
  logic te_i;  //Test enable
  logic q_o;  //Output
  logic q_model;
  int   pass = 0;//Declear a signal and initializing with 0
  int   fail = 0;//Declear a signal and initializing with 0

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTL
  //////////////////////////////////////////////////////////////////////////////////////////////////

  //Dut instantiation
  clk_gate u_clk_gate (
      .cp_i(cp_i),
      .e_i (e_i),
      .te_i(te_i),
      .q_o (q_o)
  );

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-Method
  //////////////////////////////////////////////////////////////////////////////////////////////////

  //Make a reference Model using function
  function automatic logic q_out(logic cp_i, logic e_i, logic te_i);
    logic temp;
    temp = cp_i & e_i;
    if (te_i == 1) q_out = cp_i;
    else q_out = temp;
  endfunction

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-Procedural
  //////////////////////////////////////////////////////////////////////////////////////////////////

  //Generate dump.vcd file for waveform
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end

  initial begin
    repeat (200) begin
      // Randomize data and call reference model function
      cp_i <= $urandom;
      te_i <= $urandom;
      e_i  <= $urandom;
      #1;
      q_model = q_out(cp_i, e_i, te_i);
      // Compare actual data with expected data that come from reference model
      if (q_o == q_model) pass++;  // counting match time
      else fail++;
    end
    // Dispaly data to know how many time data is passed and failed
    $display("%d Time Passed", pass);
    $display("%d Time Failed", fail);
    #100 $finish;
  end
endmodule
