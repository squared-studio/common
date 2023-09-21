// ### Author : Foez Ahmed (foez.official@gmail.com)


`define HANDSHAKE_SEND_RECV_LOOK(__NAME__, __TYPE__, __clk__, __CHAN__, __VALID__, __READY__)      \
  /*--------------------------------------------------------------------------------------------*/ \
  int ``__NAME__``_send_id = 0;                                                                    \
  int ``__NAME__``_send_queue  [$];                                                                \
  task automatic send_``__NAME__``(input ``__TYPE__`` beat);                                       \
    int thread_id;                                                                                 \
    thread_id = ``__NAME__``_send_id;                                                              \
    ``__NAME__``_send_id++;                                                                        \
    ``__NAME__``_send_queue.push_back(thread_id);                                                  \
    while (``__NAME__``_send_queue[0] != thread_id) @(posedge ``__clk__``);                        \
    ``__CHAN__``  <= beat;                                                                         \
    ``__VALID__`` <= '1;                                                                           \
    do @ (posedge ``__clk__``);                                                                    \
    while (``__READY__`` !== '1);                                                                  \
    ``__VALID__`` <= '0;                                                                           \
    ``__NAME__``_send_queue.delete(0);                                                             \
  endtask                                                                                          \
  /*--------------------------------------------------------------------------------------------*/ \
  int ``__NAME__``_recv_id = 0;                                                                    \
  int ``__NAME__``_recv_queue  [$];                                                                \
  task automatic recv_``__NAME__``(output ``__TYPE__`` beat);                                      \
    int thread_id;                                                                                 \
    thread_id = ``__NAME__``_recv_id;                                                              \
    ``__NAME__``_recv_id++;                                                                        \
    ``__NAME__``_recv_queue.push_back(thread_id);                                                  \
    while (``__NAME__``_recv_queue[0] != thread_id) @(posedge ``__clk__``);                        \
    ``__READY__`` <= '1;                                                                           \
    do @ (posedge ``__clk__``);                                                                    \
    while (``__VALID__`` !== '1);                                                                  \
    beat = ``__CHAN__``;                                                                           \
    ``__READY__`` <= '0;                                                                           \
    ``__NAME__``_recv_queue.delete(0);                                                             \
  endtask                                                                                          \
  /*--------------------------------------------------------------------------------------------*/ \
  int ``__NAME__``_look_id = 0;                                                                    \
  int ``__NAME__``_look_queue  [$];                                                                \
  task automatic look_``__NAME__``(output ``__TYPE__`` beat);                                      \
    int thread_id;                                                                                 \
    thread_id = ``__NAME__``_look_id;                                                              \
    ``__NAME__``_look_id++;                                                                        \
    ``__NAME__``_look_queue.push_back(thread_id);                                                  \
    while (``__NAME__``_look_queue[0] != thread_id) @(posedge ``__clk__``);                        \
    do @ (posedge ``__clk__``);                                                                    \
    while (``__VALID__`` !== '1 || ``__READY__`` !== '1);                                          \
    beat = ``__CHAN__``;                                                                           \
    ``__NAME__``_look_queue.delete(0);                                                             \
  endtask                                                                                          \
  /*--------------------------------------------------------------------------------------------*/ \


`define VALID_ONLY_DRIVE_CATCH(__NAME__, __TYPE__, __clk__, __CHAN__, __VALID__)                   \
  /*--------------------------------------------------------------------------------------------*/ \
  int ``__NAME__``_drive_id = 0;                                                                   \
  int ``__NAME__``_drive_queue  [$];                                                               \
  task automatic drive_``__NAME__``(input ``__TYPE__`` beat);                                      \
    int thread_id;                                                                                 \
    thread_id = ``__NAME__``_drive_id;                                                             \
    ``__NAME__``_drive_id++;                                                                       \
    ``__NAME__``_drive_queue.push_back(thread_id);                                                 \
    while (``__NAME__``_drive_queue[0] != thread_id) @(posedge ``__clk__``);                       \
    ``__CHAN__``  <= beat;                                                                         \
    ``__VALID__`` <= '1;                                                                           \
    @ (posedge ``__clk__``);                                                                       \
    ``__VALID__`` <= '0;                                                                           \
    ``__NAME__``_drive_queue.delete(0);                                                            \
  endtask                                                                                          \
  /*--------------------------------------------------------------------------------------------*/ \
  int ``__NAME__``_catch_id = 0;                                                                   \
  int ``__NAME__``_catch_queue  [$];                                                               \
  task automatic catch_``__NAME__``(output ``__TYPE__`` beat);                                     \
    int thread_id;                                                                                 \
    thread_id = ``__NAME__``_catch_id;                                                             \
    ``__NAME__``_catch_id++;                                                                       \
    ``__NAME__``_catch_queue.push_back(thread_id);                                                 \
    while (``__NAME__``_catch_queue[0] != thread_id) @(posedge ``__clk__``);                       \
    do @ (posedge ``__clk__``);                                                                    \
    while (``__VALID__`` !== '1);                                                                  \
    beat = ``__CHAN__``;                                                                           \
    ``__NAME__``_catch_queue.delete(0);                                                            \
  endtask                                                                                          \
  /*--------------------------------------------------------------------------------------------*/ \


`define WAIT_LEVEL(__NAME__, __SIGNAL__)                                                           \
  task automatic wait_``__NAME__``(input bit val = 1);                                             \
    while (``__SIGNAL__`` !== val) @(``__SIGNAL__``);                                              \
  endtask                                                                                          \
  /*--------------------------------------------------------------------------------------------*/ \

