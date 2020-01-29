#--- Exercise with morse signals, both encoding and decoding messages using a
#    tree with morse mappings from chars to morse code

defmodule Morse do

  def code do
    '.- .-.. .-.. ..-- -.-- --- ..- .-. ..-- -... .- ... . ..-- .- .-. . ..-- -... . .-.. --- -. --. ..-- - --- ..-- ..- ...'
  end

  def text do
    'morse is outdated'
  end

  #--- Decoding
  def decode(list) when is_list(list), do: decode(list, decode_table, [])

  def decode([], _, words), do: words
  def decode([?- | rest], {_, _, left, _}, words), do: decode(rest, left, words)
  def decode([?. | rest], {_, _, _, right}, words), do: decode(rest, right, words)
  def decode([32 | rest], {_, char, _, _}, words), do: decode(rest, decode_table, words ++ [char])
  def decode([?\s | rest], {_, :na, _, _}, words) do
    decode(rest, decode_table, words)
  end


  defp lookup(char, table) do
    encoding = List.keyfind(table, char, 0)
    elem(encoding, 1)
  end

  #--- Encoding
  def encode(text) do
    table = encode_table()
    encode(text, table)
  end

  def encode([], _), do: []
  def encode([char | message], table) do
    code = lookup(char, table)
    code ++ ['\s'] ++ encode(message, table)
  end


  defp encode_table, do: codes()

  def append(list1, list2), do: list1 ++ list2



  defp decode_table do
  {:node, :na,
    {:node, 116,
      {:node, 109,
        {:node, 111,
          {:node, :na, {:node, 48, nil, nil}, {:node, 57, nil, nil}},
          {:node, :na, nil, {:node, 56, nil, {:node, 58, nil, nil}}}},
        {:node, 103,
          {:node, 113, nil, nil},
          {:node, 122,
            {:node, :na, {:node, 44, nil, nil}, nil},
            {:node, 55, nil, nil}}}},
      {:node, 110,
        {:node, 107, {:node, 121, nil, nil}, {:node, 99, nil, nil}},
        {:node, 100,
          {:node, 120, nil, nil},
          {:node, 98, nil, {:node, 54, {:node, 45, nil, nil}, nil}}}}},
    {:node, 101,
      {:node, 97,
        {:node, 119,
          {:node, 106,
            {:node, 49, {:node, 47, nil, nil}, {:node, 61, nil, nil}},
            nil},
          {:node, 112,
            {:node, :na, {:node, 37, nil, nil}, {:node, 64, nil, nil}},
            nil}},
        {:node, 114,
          {:node, :na, nil, {:node, :na, {:node, 46, nil, nil}, nil}},
          {:node, 108, nil, nil}}},
      {:node, 105,
        {:node, 117,
          {:node, 32,
            {:node, 50, nil, nil},
            {:node, :na, nil, {:node, 63, nil, nil}}},
          {:node, 102, nil, nil}},
        {:node, 115,
          {:node, 118, {:node, 51, nil, nil}, nil},
          {:node, 104, {:node, 52, nil, nil}, {:node, 53, nil, nil}}}}}}
  end

  defp codes do
    [{32, '..--'},
    {37,'.--.--'},
    {44,'--..--'},
    {45,'-....-'},
    {46,'.-.-.-'},
    {47,'.-----'},
    {48,'-----'},
    {49,'.----'},
    {50,'..---'},
    {51,'...--'},
    {52,'....-'},
    {53,'.....'},
    {54,'-....'},
    {55,'--...'},
    {56,'---..'},
    {57,'----.'},
    {58,'---...'},
    {61,'.----.'},
    {63,'..--..'},
    {64,'.--.-.'},
    {97,'.-'},
    {98,'-...'},
    {99,'-.-.'},
    {100,'-..'},
    {101,'.'},
    {102,'..-.'},
    {103,'--.'},
    {104,'....'},
    {105,'..'},
    {106,'.---'},
    {107,'-.-'},
    {108,'.-..'},
    {109,'--'},
    {110,'-.'},
    {111,'---'},
    {112,'.--.'},
    {113,'--.-'},
    {114,'.-.'},
    {115,'...'},
    {116,'-'},
    {117,'..-'},
    {118,'...-'},
    {119,'.--'},
    {120,'-..-'},
    {121,'-.--'},
    {122,'--..'}]
  end


end


#IO.puts Morse.decode(Morse.code)
IO.puts Morse.encode(Morse.text)
