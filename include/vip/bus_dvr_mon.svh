// ### Author : Foez Ahmed (foez.official@gmail.com)


`define HANDSHAKE_SEND_RECV_LOOK(__NAME__, __TYPE__, __clk__, __CHAN__, __VALID__, __READY__)      \
  task automatic send_``__NAME__``(input ``__TYPE__`` beat);                                       \
    ``__CHAN__``  <= beat;                                                                         \
    ``__VALID__`` <= '1;                                                                           \
    do @ (posedge ``__clk__``);                                                                    \
    while (``__READY__`` !== '1);                                                                  \
    ``__VALID__`` <= '0;                                                                           \
  endtask                                                                                          \
  task automatic recv_``__NAME__``(output ``__TYPE__`` beat);                                      \
    ``__READY__`` <= '1;                                                                           \
    do @ (posedge ``__clk__``);                                                                    \
    while (``__VALID__`` !== '1);                                                                  \
    beat = ``__CHAN__``;                                                                           \
    ``__READY__`` <= '0;                                                                           \
  endtask                                                                                          \
  task automatic look_``__NAME__``(output ``__TYPE__`` beat);                                      \
    do @ (posedge ``__clk__``);                                                                    \
    while (``__VALID__`` !== '1 || ``__READY__`` !== '1);                                          \
    beat = ``__CHAN__``;                                                                           \
  endtask                                                                                          \


`define VALID_ONLY_DRIVE_CATCH(__NAME__, __TYPE__, __clk__, __CHAN__, __VALID__)                   \
  task automatic drive_``__NAME__``(input ``__TYPE__`` beat);                                      \
    ``__CHAN__``  <= beat;                                                                         \
    ``__VALID__`` <= '1;                                                                           \
    @ (posedge ``__clk__``);                                                                       \
    ``__VALID__`` <= '0;                                                                           \
  endtask                                                                                          \
  task automatic catch_``__NAME__``(output ``__TYPE__`` beat);                                     \
    do @ (posedge ``__clk__``);                                                                    \
    while (``__VALID__`` !== '1);                                                                  \
    beat = ``__CHAN__``;                                                                           \
  endtask                                                                                          \

