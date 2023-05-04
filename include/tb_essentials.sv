////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : ...
//    DESCRIPTION : ...
//
////////////////////////////////////////////////////////////////////////////////////////////////////

initial begin
    $dumpfile("raw.vcd");
    $dumpvars;
    $display("%c[7;38m####################### TEST STARTED #######################%c[0m", 27, 27);
end
final begin
    $display("%c[7;38m######################## TEST ENDED ########################%c[0m", 27, 27);
end

string top_module_name = $sformatf("%m");

function automatic void result_print (bit PASS, string msg);
    if (PASS) begin
        $sformat(msg, "%c[1;32m[PASS]%c[0m %s", 27, 27, msg);
    end
    else begin
        $sformat(msg, "%c[1;31m[FAIL]%c[0m %s", 27, 27, msg);
    end
    $sformat(msg, "%s %c[1;33m[%s]%c[0m", msg, 27, top_module_name, 27);
    $display(msg);
endfunction

// task automatic start_clock (output clk, input int dHIGH = 0, input int dLOW = 0);
//     fork
//         forever begin
//             clk = 1; #((dHIGH==0) ? 5 : dHIGH);
//             clk = 0; #((dLOW==0) ? ((dHIGH==0) ? 5 : dHIGH) : dLOW);
//         end
//     join_none
// endtask
