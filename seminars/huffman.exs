defmodule Huffman do

  def main do

  end
  def sample do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off'
  end

  def some_text do
    'lllll'
  end

  def text() do
    'this is something that we should encode'
  end

  def test do
    sample = sample()
    tree = tree(sample)
    encode = encode_table(tree)
    #decode = decode_table(tree)
    #text = text()
    #seq = encode(text, encode)
    #decode(seq, decode)
  end

  def tree(sample) do
    freq = freq(sample)
    huffman(freq)
  end


  def freq(sample), do: freq(sample, [])
  def freq([], freq), do: Support.insertion_srt(freq)
  def freq([ch | rest], freq), do: freq(rest, count(ch, freq))

  def count(ch, []), do: [{ch, 1}]
  def count(ch, [{ch, occurrence} | rest]), do: [{ch, occurrence + 1} | rest]
  def count(ch, [{not_this, occurence} | rest]), do: [{not_this, occurence} | count(ch, rest)]

  def huffman([tree]), do: tree
  def huffman(list = [{c1, f1}, {c2, f2} | rest]) do
    huffman(Support.insert({{c1, c2}, f1 + f2}, rest))
  end

  def encode_table(tree), do: encode_table(tree, [])

  def encode_table({a, b}, direction), do:
    encode_table(a, [0 | direction]) ++ encode_table(b, [1 | direction])

  def encode_table(a, code), do:
  [{a, Enum.reverse(code)}]


  def decode_table(tree) do
    # To implement...
  end

  def encode(text, table) do
  # To implement...
  end

  def decode(seq, tree) do
  # To implement...
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
