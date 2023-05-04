initial begin
    $dumpfile("raw.vcd");
    $dumpvars;
    $display("%c[7;38m################################# TEST STARTED #################################%c[0m", 27, 27);
end
final begin
    $display("%c[7;38m################################## TEST ENDED ##################################%c[0m", 27, 27);
end

string __TOP_NAME__ = $sformatf("%m");

function void result_print (bit PASS, string msg);
    if (PASS) begin 
        $sformat(msg, "%c[1;32m[PASS]%c[0m %s", 27, 27, msg); 
    end 
    else begin 
        int fd;
        fd = $fopen ("error_log", "a");
        $sformat(msg, "%c[1;31m[FAIL]%c[0m %s", 27, 27, msg);
        $fwrite(fd, "%s %c[1;33m[%s]%c[0m\n", msg, 27, __TOP_NAME__, 27);
        $fclose(fd); 
    end
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