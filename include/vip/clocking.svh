`define CLOCK_GLITCH_MONITOR(__CLK__, __ARST_N__, __TIME_PERIOD_HIGH__, __TIME_PERIOD_LOW__)       \
  bit ``__CLK__``_``__TIME_PERIOD_HIGH__``_``__TIME_PERIOD_LOW__``_fail = 0;                       \
  initial begin                                                                                    \
    realtime last_edge = 0;                                                                        \
    realtime this_edge = 0;                                                                        \
    realtime edge_duration = 0;                                                                    \
    forever begin                                                                                  \
      if (~``__ARST_N__``) begin                                                                   \
        last_edge = 0;                                                                             \
        this_edge = 0;                                                                             \
      end else begin                                                                               \
        if (``__CLK__``) @(negedge ``__CLK__``);                                                   \
        else @(posedge ``__CLK__``);                                                               \
        this_edge = $realtime;                                                                     \
        edge_duration = this_edge - last_edge;                                                     \
        last_edge = this_edge;                                                                     \
        if (``__CLK__``) begin                                                                     \
          if (edge_duration < ``__TIME_PERIOD_LOW__``) begin                                       \
            $warning(`"``__CLK__`` low duration is less than %0f`", ``__TIME_PERIOD_LOW__``);      \
            ``__CLK__``_``__TIME_PERIOD_HIGH__``_``__TIME_PERIOD_LOW__``_fail = 1;                 \
          end                                                                                      \
        end else begin                                                                             \
          if (edge_duration < ``__TIME_PERIOD_HIGH__``) begin                                      \
            $warning(`"``__CLK__`` high duration is less than %0f`", ``__TIME_PERIOD_HIGH__``);    \
            ``__CLK__``_``__TIME_PERIOD_HIGH__``_``__TIME_PERIOD_LOW__``_fail = 1;                 \
          end                                                                                      \
        end                                                                                        \
      end                                                                                          \
    end                                                                                            \
  end                                                                                              \
/*-----------------------------------------------------------------------------------------------*/\
  final begin                                                                                      \
    result_print(!``__CLK__``_``__TIME_PERIOD_HIGH__``_``__TIME_PERIOD_LOW__``_fail,               \
      `"Glitch Free ``__CLK__```");                                                                \
  end                                                                                              \


`define CLK_MATCHING(__EN__, __SRC_CLK__, __DEST_CLK__)                                            \
  bit ``__SRC_CLK__``_``__DEST_CLK__``_sync_fail = 0;                                              \
  always @ (``__SRC_CLK__``) begin                                                                 \
    #1fs;                                                                                          \
    if (``__EN__``) begin                                                                          \
      if (``__DEST_CLK__`` !== ``__SRC_CLK__``) begin                                              \
        $warning(`"``__DEST_CLK__`` does not match with ``__SRC_CLK__```");                        \
        ``__SRC_CLK__``_``__DEST_CLK__``_sync_fail = 1;                                            \
      end                                                                                          \
    end                                                                                            \
  end                                                                                              \
/*-----------------------------------------------------------------------------------------------*/\
  final begin                                                                                      \
    result_print(!``__SRC_CLK__``_``__DEST_CLK__``_sync_fail,                                      \
      `"``__SRC_CLK__`` & ``__DEST_CLK__`` sync`");                                                \
  end                                                                                              \

