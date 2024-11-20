/*
Author : Foez Ahmed (foez.official@gmail.com)
This file is part of squared-studio:common
Copyright (c) 2024 squared-studio
Licensed under the MIT License
See LICENSE file in the project root for full license information
*/

`ifndef MEMORY_OPS_SVH
`define MEMORY_OPS_SVH

`define LOAD_HEX(__FILE_PATH__, __MEM__)                                                          \
  begin                                                                                           \
    int file_descriptor;                                                                          \
    string line_read;                                                                             \
    longint mem_ptr;                                                                              \
    file_descriptor = $fopen(``__FILE_PATH__``, "r");                                             \
    mem_ptr = 0;                                                                                  \
    while (!$feof(                                                                                \
        file_descriptor                                                                           \
    )) begin                                                                                      \
      int start_index;                                                                            \
      bit x;                                                                                      \
      x = $fgets(line_read, file_descriptor);                                                     \
      line_read = line_read.toupper();                                                            \
      start_index = 0;                                                                            \
      while (start_index < line_read.len()) begin                                                 \
        case (line_read[start_index])                                                             \
          "@": begin                                                                              \
            start_index++;                                                                        \
            mem_ptr = '0;                                                                         \
            while (1) begin                                                                       \
              case (line_read[start_index])                                                       \
                "0": mem_ptr = ((mem_ptr << 4) | 'h0);                                            \
                "1": mem_ptr = ((mem_ptr << 4) | 'h1);                                            \
                "2": mem_ptr = ((mem_ptr << 4) | 'h2);                                            \
                "3": mem_ptr = ((mem_ptr << 4) | 'h3);                                            \
                "4": mem_ptr = ((mem_ptr << 4) | 'h4);                                            \
                "5": mem_ptr = ((mem_ptr << 4) | 'h5);                                            \
                "6": mem_ptr = ((mem_ptr << 4) | 'h6);                                            \
                "7": mem_ptr = ((mem_ptr << 4) | 'h7);                                            \
                "8": mem_ptr = ((mem_ptr << 4) | 'h8);                                            \
                "9": mem_ptr = ((mem_ptr << 4) | 'h9);                                            \
                "A": mem_ptr = ((mem_ptr << 4) | 'hA);                                            \
                "B": mem_ptr = ((mem_ptr << 4) | 'hB);                                            \
                "C": mem_ptr = ((mem_ptr << 4) | 'hC);                                            \
                "D": mem_ptr = ((mem_ptr << 4) | 'hD);                                            \
                "E": mem_ptr = ((mem_ptr << 4) | 'hE);                                            \
                "F": mem_ptr = ((mem_ptr << 4) | 'hF);                                            \
                default: break;                                                                   \
              endcase                                                                             \
              start_index++;                                                                      \
            end                                                                                   \
          end                                                                                     \
          "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F": begin   \
            ``__MEM__``[mem_ptr] = '0;                                                            \
            while (1) begin                                                                       \
              case (line_read[start_index])                                                       \
                "0": ``__MEM__``[mem_ptr] = ((``__MEM__``[mem_ptr] << 4) | 'h0);                  \
                "1": ``__MEM__``[mem_ptr] = ((``__MEM__``[mem_ptr] << 4) | 'h1);                  \
                "2": ``__MEM__``[mem_ptr] = ((``__MEM__``[mem_ptr] << 4) | 'h2);                  \
                "3": ``__MEM__``[mem_ptr] = ((``__MEM__``[mem_ptr] << 4) | 'h3);                  \
                "4": ``__MEM__``[mem_ptr] = ((``__MEM__``[mem_ptr] << 4) | 'h4);                  \
                "5": ``__MEM__``[mem_ptr] = ((``__MEM__``[mem_ptr] << 4) | 'h5);                  \
                "6": ``__MEM__``[mem_ptr] = ((``__MEM__``[mem_ptr] << 4) | 'h6);                  \
                "7": ``__MEM__``[mem_ptr] = ((``__MEM__``[mem_ptr] << 4) | 'h7);                  \
                "8": ``__MEM__``[mem_ptr] = ((``__MEM__``[mem_ptr] << 4) | 'h8);                  \
                "9": ``__MEM__``[mem_ptr] = ((``__MEM__``[mem_ptr] << 4) | 'h9);                  \
                "A": ``__MEM__``[mem_ptr] = ((``__MEM__``[mem_ptr] << 4) | 'hA);                  \
                "B": ``__MEM__``[mem_ptr] = ((``__MEM__``[mem_ptr] << 4) | 'hB);                  \
                "C": ``__MEM__``[mem_ptr] = ((``__MEM__``[mem_ptr] << 4) | 'hC);                  \
                "D": ``__MEM__``[mem_ptr] = ((``__MEM__``[mem_ptr] << 4) | 'hD);                  \
                "E": ``__MEM__``[mem_ptr] = ((``__MEM__``[mem_ptr] << 4) | 'hE);                  \
                "F": ``__MEM__``[mem_ptr] = ((``__MEM__``[mem_ptr] << 4) | 'hF);                  \
                default: break;                                                                   \
              endcase                                                                             \
              start_index++;                                                                      \
            end                                                                                   \
            mem_ptr++;                                                                            \
          end                                                                                     \
          default: begin                                                                          \
            start_index = start_index + 1;                                                        \
          end                                                                                     \
        endcase                                                                                   \
      end                                                                                         \
    end                                                                                           \
    $fclose(file_descriptor);                                                                     \
  end                                                                                             \


`define SAVE_HEX(__FILE_PATH__, __MEM__)                                                          \
  begin                                                                                           \
    int file_descriptor;                                                                          \
    bit put_addr;                                                                                 \
    file_descriptor = $fopen(``__FILE_PATH__``, "w");                                             \
    put_addr = 0;                                                                                 \
    foreach (``__MEM__``[i]) begin                                                                \
        $fdisplay(file_descriptor, "@%h\n%h", i, ``__MEM__``[i]);                                 \
    end                                                                                           \
    $fclose(file_descriptor);                                                                     \
  end                                                                                             \


`endif
