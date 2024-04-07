// ### Author : Foez Ahmed (foez.official@gmail.com)

`ifndef TB_ESS_SV
`define TB_ESS_SV

`ifndef CONGIF
  `define CONFIG "default"
`endif  // CONGIF

`define CREATE_CLK(__CLK__, __HIGH__, __LOW__)                                                     \
  bit ``__CLK__`` = '0;                                                                            \
  task static start_``__CLK__``();                                                                 \
    fork                                                                                           \
      forever begin                                                                                \
        ``__CLK__`` <= 1; #``__HIGH__``;                                                           \
        ``__CLK__`` <= 0; #``__LOW__``;                                                            \
      end                                                                                          \
    join_none                                                                                      \
  endtask                                                                                          \

string top_module_name = $sformatf("%m %s", `CONFIG);

initial begin
  $display("\033[7;38m####################### TEST STARTED #######################\033[0m");
`ifdef ENABLE_DUMPFILE
  $dumpfile("dump.vcd");
  $dumpvars;
`endif  // ENABLE_DUMPFILE
  $timeformat(-6, 3, "us");
  #1s;
  result_print(0, $sformatf("\033[1;31m[FATAL][TIMEOUT]\033[0m"));
  $finish;
end

final begin
  $display("\033[7;38m######################## TEST ENDED ########################\033[0m");
end

function automatic void result_print(bit PASS, string msg);
  if (PASS == 0) $sformat(msg, "\033[1;31m[FAIL]\033[0m %s", msg);
  else $sformat(msg, "\033[1;32m[PASS]\033[0m %s", msg);
  $sformat(msg, "%s \033[1;33m[%s]\033[0m", msg, top_module_name);
  $display(msg);
endfunction

`endif
