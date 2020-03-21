#--- Seminar 1 huffman coding
# task was to implement the huffman compression algorithm, that maps each letter
# and its with a binary based on the letters frequency using a huffman tree

defmodule Huffman do

  def sample do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off'
  end

  def text() do
    'this is something that we should encode'
  end

  def test do
    sample = sample()
    tree = tree(sample)
    encode = encode_table(tree)
    decode = decode_table(tree)
    text = text()
    seq = encode(text, encode)
    decode(seq, decode)
  end

  def tree(sample) do
    freq = freq(sample)
    huffman(freq)
  end

  # function goes through each word in a list, adding count for every occurrence
  # and sorts list in the end
  def freq(sample), do: freq(sample, [])
  def freq([], freq), do: Support.insertion_srt(freq)
  def freq([ch | rest], freq), do: freq(rest, count(ch, freq))

  # adds one to counter if word is found in our frequency list
  def count(ch, []), do: [{ch, 1}]
  def count(ch, [{ch, occurrence} | rest]), do: [{ch, occurrence + 1} | rest]
  def count(ch, [{not_this, occurence} | rest]), do: [{not_this, occurence} | count(ch, rest)]

  # takes two smallest frequencies, makes them one node by adding both frequencies
  # and puts into list
  def huffman([tree]), do: tree
  def huffman([{c1, f1}, {c2, f2} | rest]) do
    huffman(Support.insert({{c1, c2}, f1 + f2}, rest))
  end

  def encode_table(tree), do: get_codes(tree, [])

  def decode_table(tree), do: get_codes(tree, [])

  # goes through every possible leaf and records the path with 0's and 1's to get there
  def get_codes({a, b}, direction), do:
    get_codes(a, [0 | direction]) ++ get_codes(b, [1 | direction])
  def get_codes(a, code), do: [{a, Enum.reverse(code)}]

  def encode([], table), do: []
  def encode([ch | rest], table), do: contains(ch, table) ++ encode(rest, table)

  def contains(ch, []), do: []
  def contains(ch, [{ch, code} | rest]), do: code
  def contains(ch, [{not_this, _} | rest]), do: contains(ch, rest)


  def decode([], _), do: []

  def decode(seq, table) do
    {char, rest} = decode_char(seq, 1, table)
    [char | decode(rest, table)]
  end

  # extracts letters from decode table based on the binary code
  def decode_char(seq, n, table) do
    {code, rest} = Enum.split(seq, n)
    case List.keyfind(table, code, 1) do
      {ch, code} ->
        {ch, rest}
      nil ->
        decode_char(seq, n + 1, table)
    end

  end

end

# support functions
defmodule Support do
  # insertion sort
  def insertion_srt([]), do: []
  def insertion_srt(list) when is_list(list), do: insertion_srt(list, [])

  def insertion_srt([], res) when is_list(res), do: res
  def insertion_srt([h | t], []), do: insertion_srt(t, [h])
  def insertion_srt([c1 | t1], list = [c2 | t2]), do:
    insertion_srt(t1, insert(c1, list))

  # place input element in correct spot such that the list is sorted
  def insert(p1, []), do: [p1]
  def insert(p1 = {_, f1}, [p2 = {_, f2} | rest]) when f2 <= f1, do:
    [p2 | insert(p1, rest)]
  def insert(p1, [p2 | rest]), do: [p1, p2 | rest]
end

IO.inspect Huffman.test()
