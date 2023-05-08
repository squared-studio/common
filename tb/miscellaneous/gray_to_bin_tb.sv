// Code your testbench here
// or browse Examples
////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Razu
//    EMAIL       : ...
//
//    MODULE      : ...
//    DESCRIPTION : ...
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module bin_to_gray_tb;

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // IMPORTS
    ////////////////////////////////////////////////////////////////////////////////////////////////////

        //`include "tb_essentials.sv"

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // LOCALPARAMS
    ////////////////////////////////////////////////////////////////////////////////////////////////////

        localparam int DataWidth = 4;

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // TYPEDEFS
    ////////////////////////////////////////////////////////////////////////////////////////////////////



    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // SIGNALS
    ////////////////////////////////////////////////////////////////////////////////////////////////////


        logic [DataWidth-1:0] data_in_i;
        logic [DataWidth-1:0] data_out_o;

        logic [DataWidth-1:0] data_out_o_actual_queue[$];
        logic [DataWidth-1:0] data_out_o_exp_queue[$];
        logic [DataWidth-1:0] data_buffer;      
        logic [DataWidth-1:0] temp_actual,temp_exp;
        int pass;
        int fail;
  		int count;

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // INTERFACES
    ////////////////////////////////////////////////////////////////////////////////////////////////////



    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // CLASSES
    ////////////////////////////////////////////////////////////////////////////////////////////////////



    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // ASSIGNMENTS
    ////////////////////////////////////////////////////////////////////////////////////////////////////



    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // RTLS
    ////////////////////////////////////////////////////////////////////////////////////////////////////

        gray_to_bin #(
            .DataWidth (DataWidth)
        ) gray_to_bin_dut (
            .data_in_i  ( data_in_i  ),
            .data_out_o ( data_out_o )
        );

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // METHODS
    ////////////////////////////////////////////////////////////////////////////////////////////////////


    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // PROCEDURALS
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    
  
      function logic  [DataWidth-1:0]data_out_gray_to_bin(logic  [DataWidth-1:0] data_in);
        data_out_gray_to_bin [3] = data_in [3];
        for (int i = DataWidth-2; i >= 0; i--) begin
          data_out_gray_to_bin [i] = data_out_gray_to_bin [i+1] ^ data_in [i];
        end
      endfunction
 
  
      initial begin
          $dumpfile("raw.vcd");
          $dumpvars();
      end

      initial
      begin 
          data_in_i = 4'b0000; 
          data_buffer= data_out_gray_to_bin(data_in_i);
          #1;
          data_out_o_exp_queue.push_back(data_buffer);
          data_out_o_actual_queue.push_back(data_out_o);
          count++;
          
          data_in_i = 4'b0001;
          data_buffer= data_out_gray_to_bin(data_in_i);
          #1;
          data_out_o_exp_queue.push_back(data_buffer);
          data_out_o_actual_queue.push_back(data_out_o);
          count++;
          
          data_in_i = 4'b0011;
          data_buffer= data_out_gray_to_bin(data_in_i);
          #1;
          data_out_o_exp_queue.push_back(data_buffer);
          data_out_o_actual_queue.push_back(data_out_o);
          count++;
          
          data_in_i = 4'b0010;
          data_buffer= data_out_gray_to_bin(data_in_i);
          #1;
          data_out_o_exp_queue.push_back(data_buffer);
          data_out_o_actual_queue.push_back(data_out_o);
          count++;
          
          data_in_i = 4'b0110;
          data_buffer= data_out_gray_to_bin(data_in_i);
          #1;
          data_out_o_exp_queue.push_back(data_buffer);
          data_out_o_actual_queue.push_back(data_out_o);
          count++;
          
          data_in_i = 4'b0111;
          data_buffer= data_out_gray_to_bin(data_in_i);
          #1;
          data_out_o_exp_queue.push_back(data_buffer);
          data_out_o_actual_queue.push_back(data_out_o);
          count++;
          
          data_in_i = 4'b0101;
          data_buffer= data_out_gray_to_bin(data_in_i);
          #1;
          data_out_o_exp_queue.push_back(data_buffer);
          data_out_o_actual_queue.push_back(data_out_o);
          count++;
          
          data_in_i = 4'b0100;
          data_buffer= data_out_gray_to_bin(data_in_i);
          #1;
          data_out_o_exp_queue.push_back(data_buffer);
          data_out_o_actual_queue.push_back(data_out_o);
          count++;
          
          data_in_i = 4'b1100;
          data_buffer= data_out_gray_to_bin(data_in_i);
          #1;
          data_out_o_exp_queue.push_back(data_buffer);
          data_out_o_actual_queue.push_back(data_out_o);
          count++;
          
          data_in_i = 4'b1101;
          data_buffer= data_out_gray_to_bin(data_in_i);
          #1;
          data_out_o_exp_queue.push_back(data_buffer);
          data_out_o_actual_queue.push_back(data_out_o);
          count++;
          
          data_in_i = 4'b1111;
          data_buffer= data_out_gray_to_bin(data_in_i);
          #1;
          data_out_o_exp_queue.push_back(data_buffer);
          data_out_o_actual_queue.push_back(data_out_o);
          count++;
          
          data_in_i = 4'b1110;
          data_buffer= data_out_gray_to_bin(data_in_i);
          #1;
          data_out_o_exp_queue.push_back(data_buffer);
          data_out_o_actual_queue.push_back(data_out_o);
          count++;
         
          data_in_i = 4'b1010;
          data_buffer= data_out_gray_to_bin(data_in_i);
          #1;
          data_out_o_exp_queue.push_back(data_buffer);
          data_out_o_actual_queue.push_back(data_out_o);
          count++;
          
          data_in_i = 4'b1011;
          data_buffer= data_out_gray_to_bin(data_in_i);
          #1;
          data_out_o_exp_queue.push_back(data_buffer);
          data_out_o_actual_queue.push_back(data_out_o);
          count++;
          
          data_in_i = 4'b1001;
          data_buffer= data_out_gray_to_bin(data_in_i);
          #1;
          data_out_o_exp_queue.push_back(data_buffer);
          data_out_o_actual_queue.push_back(data_out_o);
          count++;
          
          data_in_i = 4'b1000;
          data_buffer= data_out_gray_to_bin(data_in_i);
          #1;
          data_out_o_exp_queue.push_back(data_buffer);
          data_out_o_actual_queue.push_back(data_out_o);
          count++;
          
          #30;
          $finish;
      end
           
      initial
      begin
          #17;
          for (int i = 0; i < count; i++) begin
             temp_actual =data_out_o_actual_queue.pop_front();
             temp_exp    =data_out_o_exp_queue.pop_front();
             
             if(temp_actual == temp_exp) 
                begin
                pass++;
                $display ("actual = %b and exp = %b This is a PASS",temp_actual,temp_exp);
             end
             else 
             begin
                fail++;
                $display ("actual = %b and exp = %b And this is a FAIL",temp_actual,temp_exp);
             end
          end
          $display("%0d/%0d PASSED", pass, pass + fail);
       end
            
endmodule
