// ### Author : Foez Ahmed (foez.official@gmail.com))

`ifndef CLOCKING_SVH
`define CLOCKING_SVH

// Checks for Pulse width less than specified
`define CLK_GLITCH_MON(__ARST_N__, __CLK__, __TIME_PERIOD_HIGH__, __TIME_PERIOD_LOW__)            \
  bit ``__CLK__``_``__TIME_PERIOD_HIGH__``_``__TIME_PERIOD_LOW__``_fail = 0;                      \
  initial begin                                                                                   \
    realtime last_edge = 0;                                                                       \
    realtime this_edge = 0;                                                                       \
    realtime edge_duration = 0;                                                                   \
    forever begin                                                                                 \
      if (~``__ARST_N__``) begin                                                                  \
        last_edge = 0;                                                                            \
        this_edge = 0;                                                                            \
        @(posedge ``__ARST_N__``);                                                                \
      end else begin                                                                              \
        if (``__CLK__``) @(negedge ``__CLK__``);                                                  \
        else @(posedge ``__CLK__``);                                                              \
        this_edge = $realtime;                                                                    \
        edge_duration = this_edge - last_edge;                                                    \
        last_edge = this_edge;                                                                    \
        if (``__ARST_N__``) begin                                                                 \
          if (``__CLK__``) begin                                                                  \
            if (edge_duration < ``__TIME_PERIOD_LOW__``) begin                                    \
              $warning(`"``__CLK__`` low duration %0t is less than %0t`",                         \
                edge_duration, ``__TIME_PERIOD_LOW__``);                                          \
              ``__CLK__``_``__TIME_PERIOD_HIGH__``_``__TIME_PERIOD_LOW__``_fail = 1;              \
            end                                                                                   \
          end else begin                                                                          \
            if (edge_duration < ``__TIME_PERIOD_HIGH__``) begin                                   \
              $warning(`"``__CLK__`` high duration %0t is less than %0t`",                        \
                edge_duration, ``__TIME_PERIOD_HIGH__``);                                         \
              ``__CLK__``_``__TIME_PERIOD_HIGH__``_``__TIME_PERIOD_LOW__``_fail = 1;              \
            end                                                                                   \
          end                                                                                     \
        end                                                                                       \
      end                                                                                         \
    end                                                                                           \
  end                                                                                             \
/*----------------------------------------------------------------------------------------------*/\
  final begin                                                                                     \
    result_print(!``__CLK__``_``__TIME_PERIOD_HIGH__``_``__TIME_PERIOD_LOW__``_fail,              \
      `"Glitch Free ``__CLK__```");                                                               \
  end                                                                                             \


// Checks for Destination clock matches with source clock
`define CLK_MATCH_MON(__EN__, __SRC_CLK__, __DEST_CLK__)                                          \
  bit ``__SRC_CLK__``_``__DEST_CLK__``_match_fail = 0;                                            \
  initial begin                                                                                   \
    forever begin                                                                                 \
      @ (``__SRC_CLK__``);                                                                        \
      #1fs;                                                                                       \
      if (``__EN__`` && (``__DEST_CLK__`` !== ``__SRC_CLK__``)) begin                             \
          $warning(`"``__DEST_CLK__`` does not match with ``__SRC_CLK__```");                     \
          ``__SRC_CLK__``_``__DEST_CLK__``_match_fail = 1;                                        \
      end                                                                                         \
    end                                                                                           \
  end                                                                                             \
/*----------------------------------------------------------------------------------------------*/\
  final begin                                                                                     \
    result_print(!``__SRC_CLK__``_``__DEST_CLK__``_match_fail,                                    \
      `"``__SRC_CLK__`` & ``__DEST_CLK__`` match`");                                              \
  end                                                                                             \


// Clock gate monitoring
`define CLK_GATE_MON(__ARST_N__, __EN__, __SRC_CLK__, __DEST_CLK__)                               \
  bit ``__SRC_CLK__``_``__DEST_CLK__``gating_fail = 0;                                            \
  initial begin                                                                                   \
    bit local_enable_posedge;                                                                     \
    bit local_enable_negedge;                                                                     \
    fork                                                                                          \
      forever begin                                                                               \
        @ (posedge ``__SRC_CLK__`` or negedge ``__ARST_N__);                                      \
        if (~``__ARST_N__``) begin                                                                \
          local_enable_posedge <= '0;                                                             \
        end else begin                                                                            \
          local_enable_posedge <= ``__EN__``;                                                     \
        end                                                                                       \
      end                                                                                         \
      forever begin                                                                               \
        @ (negedge ``__SRC_CLK__`` or negedge ``__ARST_N__);                                      \
        if (~``__ARST_N__``) begin                                                                \
          local_enable_negedge <= '0;                                                             \
        end else begin                                                                            \
          local_enable_negedge <= local_enable_posedge;                                           \
          #1fs;                                                                                   \
          if (local_enable_negedge && (``__DEST_CLK__`` !== ``__SRC_CLK__``)) begin               \
            $warning(`"``__DEST_CLK__`` does not respond with ``__EN__```");                      \
            ``__SRC_CLK__``_``__DEST_CLK__``gating_fail = 1;                                      \
          end                                                                                     \
        end                                                                                       \
      end                                                                                         \
    join                                                                                          \
  end                                                                                             \
/*----------------------------------------------------------------------------------------------*/\
  final begin                                                                                     \
    result_print(!``__SRC_CLK__``_``__DEST_CLK__``gating_fail,                                    \
      `"``__DEST_CLK__`` ``__EN__`` gating`");                                                    \
  end                                                                                             \


`endif
