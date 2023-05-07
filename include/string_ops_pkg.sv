////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : string_ops_pkg
//    DESCRIPTION : string manipulation operations
//
////////////////////////////////////////////////////////////////////////////////////////////////////

package string_ops_pkg;

  // Returns the decimal value after the provided keyword=
  // Example
  // string str = "inA=12 inB=15 inC=18";
  // $display("Found:%0d", string_get(str, "inB"));
  // PRINTS -> Found:15
  function automatic int string_get(string line, string word);
    string str;
    string key;
    int found;
    int d_start;
    int d_end;

    found   = 0;
    d_start = 0;
    $sformat(str, " %s ", line);
    $sformat(key, " %s=", word);

    for (int i = 0; i < str.len(); i++) begin
      if (str[i] == "\n") str[i] = " ";
    end

    for (int i = 0; (i < (str.len() - key.len()) && found == 0); i++) begin
      int matching;
      matching = 1;
      for (int j = 0; (j < key.len() && found == 0); j++) begin
        if (key[j] != str[i+j]) matching = 0;
      end
      if (matching) begin
        d_start = i + key.len();
        found   = 1;
      end
    end

    if (found) begin
      for (int i = d_start; (i < str.len() && found == 1); i++) begin
        case (str[i])
          "0", "1", "2", "3", "4", "5", "6", "7", "8", "9": d_end = i;
          default: found = 0;
        endcase
      end
    end

    $sformat(key, "%s", str.substr(d_start, d_end));

    return key.atoi();

  endfunction

  function automatic int find(string line, string word);
    int index;
    if ((word.len() < line.len()) && (word.len() > 0)) begin
      int found = 0;
      for (int i = 0; (i < (line.len() - word.len() + 1) && found == 0); i++) begin
        int matching;
        matching = 1;
        for (int j = 0; (j < word.len() && found == 0); j++) begin
          if (word[j] != line[i+j]) matching = 0;
        end
        if (matching) begin
          index = i;
          found = 1;
        end
      end
    end else index = 0;
    return index;
  endfunction

  function automatic string insert(string line, int index, string word);
    // TODO
  endfunction

endpackage
