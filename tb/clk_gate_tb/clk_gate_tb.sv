// Simple test bench for clk_gate module
// ### Author : Razu Ahamed(en.razu.ahamed@gmail.com)

module clk_gate_tb;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-IMPORTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  `include "vip/tb_ess.sv"

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  `CREATE_CLK(clk_i, 5ns, 5ns)
  logic cp_i = 0;  // Clock pulse
  logic e_i = 0;  // Enable
  logic te_i = 0;  // Test enable
  logic q_o;  // Output
  int   pass = 0;  // Declare a signal for counting match and initializing with 0
  int   fail = 0;  // Declare a signal for counting mismatch and initializing with 0

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTL
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // Dut instantiation
  clk_gate u_clk_gate (
      .cp_i(cp_i),
      .e_i (e_i),
      .te_i(te_i),
      .q_o (q_o)
  );

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-Method
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // Make a reference Model using function
  function automatic logic q_out(logic cp_i, logic e_i, logic te_i);
    logic temp;  // Declare a signal to store output of AND operation
    temp = cp_i & e_i;  // Storeing AND operation data
    if (te_i == 1) q_out = cp_i;  // Creating 2to1 MUX using if condition
    else q_out = temp;
  endfunction

  // Driver for randomized stimuluses
  task static drive();
    fork
      forever
      @(posedge clk_i) begin
        cp_i <= $urandom;
        te_i <= $urandom;
        e_i  <= $urandom;
      end
    join_none
  endtask

  // Monitoring and Scoreboard
  task static monitor_scoreboard();
    fork
      forever
      @(posedge clk_i) begin
        if (q_o == q_out(cp_i, e_i, te_i)) pass++;
        else if (q_o != q_out(cp_i, e_i, te_i)) fail++;
      end
    join_none
  endtask

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-Procedural
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // Generate dump.vcd file for waveform
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end

  initial begin

    start_clk_i();
    drive();
    monitor_scoreboard();

    //  Repeating the Test for N number of test cases - - - - > N = 100
    for (int k = 0; k < 100; k++) begin
      @(posedge clk_i);
    end

    //  Display result to know how many time data is passed and failed
    result_print(!fail, $sformatf("data matched = %0d/%0d", pass, pass + fail));
    $finish;

  end

endmodule
