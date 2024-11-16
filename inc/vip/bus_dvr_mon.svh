// ### Author : Foez Ahmed (foez.official@gmail.com)

`ifndef BUS_DVR_MON_SVH
`define BUS_DVR_MON_SVH 0

`define HANDSHAKE_SEND_RECV_LOOK(__NM__, __TP__, __CLK__, __ARST_N__, __BUS__, __VAL__, __RDY__)  \
                                                                                                  \
  int ``__NM__``_send_id = 0;                                                                     \
  int ``__NM__``_send_queue  [$];                                                                 \
  task automatic send_``__NM__``(input ``__TP__`` beat);                                          \
    int thread_id;                                                                                \
    thread_id = ``__NM__``_send_id;                                                               \
    ``__NM__``_send_id++;                                                                         \
    ``__NM__``_send_queue.push_back(thread_id);                                                   \
    while ((``__NM__``_send_queue[0] != thread_id) && (__ARST_N__ == 1))                          \
      @(posedge ``__CLK__`` or negedge ``__ARST_N__``);                                           \
    if (__ARST_N__) begin                                                                         \
      ``__BUS__``  <= beat;                                                                       \
      ``__VAL__`` <= '1;                                                                          \
      do @ (posedge ``__CLK__``);                                                                 \
      while ((``__RDY__`` !== '1) && (__ARST_N__ == 1));                                          \
      ``__VAL__`` <= '0;                                                                          \
    end                                                                                           \
    ``__NM__``_send_queue.delete(0);                                                              \
  endtask                                                                                         \
                                                                                                  \
  int ``__NM__``_recv_id = 0;                                                                     \
  int ``__NM__``_recv_queue  [$];                                                                 \
  task automatic recv_``__NM__``(output ``__TP__`` beat);                                         \
    int thread_id;                                                                                \
    thread_id = ``__NM__``_recv_id;                                                               \
    ``__NM__``_recv_id++;                                                                         \
    ``__NM__``_recv_queue.push_back(thread_id);                                                   \
    while ((``__NM__``_recv_queue[0] != thread_id) && (__ARST_N__ == 1))                          \
      @(posedge ``__CLK__`` or negedge ``__ARST_N__``);                                           \
    if (__ARST_N__) begin                                                                         \
      ``__RDY__`` <= '1;                                                                          \
      do @ (posedge ``__CLK__``);                                                                 \
      while ((``__VAL__`` !== '1) && (__ARST_N__ == 1));                                          \
      beat = ``__BUS__``;                                                                         \
      ``__RDY__`` <= '0;                                                                          \
    end                                                                                           \
    ``__NM__``_recv_queue.delete(0);                                                              \
  endtask                                                                                         \
                                                                                                  \
  int ``__NM__``_look_id = 0;                                                                     \
  int ``__NM__``_look_queue  [$];                                                                 \
  task automatic look_``__NM__``(output ``__TP__`` beat);                                         \
    int thread_id;                                                                                \
    thread_id = ``__NM__``_look_id;                                                               \
    ``__NM__``_look_id++;                                                                         \
    ``__NM__``_look_queue.push_back(thread_id);                                                   \
    while ((``__NM__``_look_queue[0] != thread_id) && (__ARST_N__ == 1))                          \
      @(posedge ``__CLK__`` or negedge ``__ARST_N__``);                                           \
    if (__ARST_N__) begin                                                                         \
      do @ (posedge ``__CLK__``);                                                                 \
      while ((``__VAL__`` !== '1 || ``__RDY__`` !== '1) && (__ARST_N__ == 1));                    \
      beat = ``__BUS__``;                                                                         \
    end                                                                                           \
    ``__NM__``_look_queue.delete(0);                                                              \
  endtask                                                                                         \
                                                                                                  \


`define VALID_ONLY_DRIVE_CATCH(__NM__, __TP__, __CLK__, __ARST_N__, __BUS__, __VAL__)             \
                                                                                                  \
  int ``__NM__``_drive_id = 0;                                                                    \
  int ``__NM__``_drive_queue  [$];                                                                \
  task automatic drive_``__NM__``(input ``__TP__`` beat);                                         \
    int thread_id;                                                                                \
    thread_id = ``__NM__``_drive_id;                                                              \
    ``__NM__``_drive_id++;                                                                        \
    ``__NM__``_drive_queue.push_back(thread_id);                                                  \
    while ((``__NM__``_drive_queue[0] != thread_id) && (__ARST_N__ == 1))                         \
      @(posedge ``__CLK__`` or negedge ``__ARST_N__``);                                           \
    if (__ARST_N__) begin                                                                         \
      ``__BUS__``  <= beat;                                                                       \
      ``__VAL__`` <= '1;                                                                          \
      @ (posedge ``__CLK__``);                                                                    \
      ``__VAL__`` <= '0;                                                                          \
    end                                                                                           \
    ``__NM__``_drive_queue.delete(0);                                                             \
  endtask                                                                                         \
                                                                                                  \
  int ``__NM__``_catch_id = 0;                                                                    \
  int ``__NM__``_catch_queue  [$];                                                                \
  task automatic catch_``__NM__``(output ``__TP__`` beat);                                        \
    int thread_id;                                                                                \
    thread_id = ``__NM__``_catch_id;                                                              \
    ``__NM__``_catch_id++;                                                                        \
    ``__NM__``_catch_queue.push_back(thread_id);                                                  \
    while ((``__NM__``_catch_queue[0] != thread_id) && (__ARST_N__ == 1))                         \
      @(posedge ``__CLK__`` or negedge ``__ARST_N__``);                                           \
    if (__ARST_N__) begin                                                                         \
      do @ (posedge ``__CLK__``);                                                                 \
      while ((``__VAL__`` !== '1) && (__ARST_N__ == 1));                                          \
      beat = ``__BUS__``;                                                                         \
    end                                                                                           \
    ``__NM__``_catch_queue.delete(0);                                                             \
  endtask                                                                                         \
                                                                                                  \


`endif
