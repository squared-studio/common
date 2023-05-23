// ### Author : Foez Ahmed (foez.official@gmail.com)

`define CREATE_CLK(__CLK__, __HIGH__, __LOW__)                                                     \
  bit ``__CLK__`` = '1;                                                                            \
  task static start_``__CLK__``();                                                                 \
    fork                                                                                           \
      forever begin                                                                                \
        clk_i = 1; #``__HIGH__``;                                                                  \
        clk_i = 0; #``__LOW__``;                                                                   \
      end                                                                                          \
    join_none                                                                                      \
  endtask                                                                                          \

string top_module_name = $sformatf("%m");

initial begin
  $display("%c[7;38m####################### TEST STARTED #######################%c[0m", 27, 27);
`ifdef ENABLE_DUMPFILE
  $dumpfile("raw.vcd");
  $dumpvars;
`endif  // ENABLE_DUMPFILE
  repeat (1000) repeat (1000) repeat (1000) #1000;
  result_print(0, $sformatf("%c[1;31m[FATAL][TIMEOUT]%c[0m", 27, 27));
  $finish;
end

final begin
  $display("%c[7;38m######################## TEST ENDED ########################%c[0m", 27, 27);
end

function automatic void result_print(bit PASS, string msg);
  if (PASS) $sformat(msg, "%c[1;32m[PASS]%c[0m %s", 27, 27, msg);
  else $sformat(msg, "%c[1;31m[FAIL]%c[0m %s", 27, 27, msg);
  $sformat(msg, "%s %c[1;33m[%s]%c[0m", msg, 27, top_module_name, 27);
  $display(msg);
endfunction
