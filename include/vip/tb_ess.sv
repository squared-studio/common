// ### Author : Foez Ahmed (foez.official@gmail.com)

`define SIMULATION

`define CREATE_CLK(__CLK__, __HIGH__, __LOW__)                                                     \
  bit ``__CLK__`` = '1;                                                                            \
  task static start_``__CLK__``();                                                                 \
    fork                                                                                           \
      forever begin                                                                                \
        ``__CLK__`` = 1; #``__HIGH__``;                                                            \
        ``__CLK__`` = 0; #``__LOW__``;                                                             \
      end                                                                                          \
    join_none                                                                                      \
  endtask                                                                                          \

string top_module_name = $sformatf("%m");

initial begin
  $display("\x1b[7;38m####################### TEST STARTED #######################\x1b[0m");
`ifdef ENABLE_DUMPFILE
  $dumpfile("raw.vcd");
  $dumpvars;
`endif  // ENABLE_DUMPFILE
  repeat (1000) repeat (1000) repeat (1000) #1000;
  result_print(0, $sformatf("\x1b[1;31m[FATAL][TIMEOUT]\x1b[0m"));
  $finish;
end

final begin
  $display("\x1b[7;38m######################## TEST ENDED ########################\x1b[0m");
end

function automatic void result_print(int PASS, string msg);
  if (PASS==0) $sformat(msg, "\x1b[1;31m[FAIL]\x1b[0m %s", msg);
  else $sformat(msg, "\x1b[1;32m[PASS]\x1b[0m %s", msg);
  $sformat(msg, "%s \x1b[1;33m[%s]\x1b[0m", msg, top_module_name);
  $display(msg);
endfunction
